import simpy
import random
import os
from datetime import datetime
import boto3
import json
import time
from config import AWS_REGION, KINESIS_STREAM_NAME, SIMULATION_ID


def send_to_aws(data, data_type="package", max_retries=3):
    for attempt in range(max_retries):
        try:
            kinesis_client = boto3.client('kinesis', region_name=AWS_REGION)
            
            # Add simulation metadata
            data['simulation_id'] = SIMULATION_ID
            data['data_type'] = data_type
            
            # Convert to JSON and encode
            payload = json.dumps(data).encode('utf-8')
            
            response = kinesis_client.put_record(
                StreamName=KINESIS_STREAM_NAME,
                Data=payload,
                PartitionKey=str(data.get('PackageID', data.get('RobotName', 'default')))
            )
            
            print(f"✅ Sent {data_type} data to Kinesis")
            return response
        except Exception as e:
            if attempt == max_retries - 1:
                print(f"❌ Exception while sending {data_type} data to Kinesis:", e)
            else:
                print(f"⚠️ Retry {attempt + 1}/{max_retries} for {data_type}")
                time.sleep(1)  # Add a small delay between retries


class Robot:
    def __init__(self, env, name, energy_use, failure_rate):
        self.env = env
        self.name = name
        self.energy_use = energy_use
        self.failure_rate = failure_rate
        self.tasks_completed = 0
        self.total_energy_used = 0
        # Use the environment's sim_id instead of generating a new one
        self.sim_id = env.sim_id
        
    def send_telemetry(self, task_type, duration):
        telemetry_data = {
            "RobotName": self.name,
            "RobotType": self.__class__.__name__,
            "TaskType": task_type,
            "Duration": duration,
            "EnergyUsed": self.energy_use,
            "TasksCompleted": self.tasks_completed,
            "TotalEnergyUsed": self.total_energy_used,
            "Timestamp": datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        }
        send_to_aws(telemetry_data, data_type="robot_telemetry")
        print(f"[Sim #{self.sim_id}] ✅ Sent telemetry for {self.name}")

    def check_failure(self):
        # Simulate a failure based on the failure rate
        if random.random() < self.failure_rate:
            print(f"❌ {self.name} failed during operation!")
            
            # Send failure data to AWS
            failure_data = {
                "RobotName": self.name,
                "Task": "Failure",
                "EnergyUse": self.energy_use,
                "Timestamp": datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S'),
                "FailureReason": "Random failure based on failure rate"
            }
            send_to_aws(failure_data, data_type="robot_failure")
            
            return True
        return False


class StowRobot(Robot):
    def __init__(self, env, name, stow_capacity, energy_use=5, failure_rate=0.01):
        super().__init__(env, name, energy_use, failure_rate)
        self.stow_capacity = stow_capacity  # Maximum number of items it can stow at once

    def stow(self, package, station):
        start_time = self.env.now
        if self.check_failure():
            yield self.env.timeout(2)  # Simulate recovery time
            return
        print(f"{self.name} is stowing {package.package_id} at {station.name}")
        yield self.env.timeout(2)  # Simulate stowing time
        print(f"{self.name} finished stowing {package.package_id} at {station.name}")
        duration = self.env.now - start_time
        self.tasks_completed += 1
        self.total_energy_used += self.energy_use
        self.send_telemetry("stow", duration)


class PickRobot(Robot):
    def __init__(self, env, name, pick_accuracy, energy_use=4, failure_rate=0.02):
        super().__init__(env, name, energy_use, failure_rate)
        self.pick_accuracy = pick_accuracy  # Accuracy percentage for picking items

    def pick(self, package, station):
        start_time = self.env.now
        if self.check_failure():
            yield self.env.timeout(2)  # Simulate recovery time
            return
        print(f"{self.name} is picking {package.package_id} at {station.name}")
        yield self.env.timeout(3)  # Simulate picking time
        print(f"{self.name} finished picking {package.package_id} at {station.name}")
        duration = self.env.now - start_time
        self.tasks_completed += 1
        self.total_energy_used += self.energy_use
        self.send_telemetry("pick", duration)


class PackRobot(Robot):
    def __init__(self, env, name, packing_speed, energy_use=6, failure_rate=0.015):
        super().__init__(env, name, energy_use, failure_rate)
        self.packing_speed = packing_speed  # Speed of packing items

    def pack(self, package, station):
        start_time = self.env.now
        if self.check_failure():
            yield self.env.timeout(2)  # Simulate recovery time
            return
        print(f"{self.name} is packing {package.package_id} at {station.name}")
        yield self.env.timeout(4 / self.packing_speed)  # Simulate packing time based on speed
        print(f"{self.name} finished packing {package.package_id} at {station.name}")
        duration = self.env.now - start_time
        self.tasks_completed += 1
        self.total_energy_used += self.energy_use
        self.send_telemetry("pack", duration)


class ShipRobot(Robot):
    def __init__(self, env, name, shipping_capacity, energy_use=7, failure_rate=0.02):
        super().__init__(env, name, energy_use, failure_rate)
        self.shipping_capacity = shipping_capacity  # Maximum number of items it can ship at once

    def ship(self, package, station):
        start_time = self.env.now
        if self.check_failure():
            yield self.env.timeout(2)  # Simulate recovery time
            return
        print(f"{self.name} is shipping {package.package_id} at {station.name}")
        yield self.env.timeout(5)  # Simulate shipping time
        print(f"{self.name} finished shipping {package.package_id} at {station.name}")
        duration = self.env.now - start_time
        self.tasks_completed += 1
        self.total_energy_used += self.energy_use
        self.send_telemetry("ship", duration)


class MoverRobot(Robot):
    def __init__(self, env, name, speed, energy_use=3, failure_rate=0.01):
        super().__init__(env, name, energy_use, failure_rate)
        self.speed = speed  # Speed of movement between stations

    def move_package(self, package, from_station, to_station):
        start_time = self.env.now
        if self.check_failure():
            yield self.env.timeout(2)  # Simulate recovery time
            return
        print(f"{self.name} is moving {package.package_id} from {from_station.name} to {to_station.name}")
        travel_time = self.calculate_travel_time(from_station, to_station)
        yield self.env.timeout(travel_time)
        print(f"{self.name} delivered {package.package_id} to {to_station.name}")
        duration = self.env.now - start_time
        self.tasks_completed += 1
        self.total_energy_used += self.energy_use
        self.send_telemetry("move", duration)

    def calculate_travel_time(self, from_station, to_station):
        # Travel time is inversely proportional to speed
        return max(1, 10 / self.speed)


class Package:
    def __init__(self, env, package_id, stations, mover_robots):
        self.env = env
        self.package_id = package_id
        self.stations = stations
        self.mover_robots = mover_robots

        # Metadata
        self.weight_kg = round(random.uniform(0.5, 10.0), 2)
        self.volume_liters = round(random.uniform(5, 50), 1)
        self.priority = random.choice(['Low', 'Standard', 'High'])
        self.destination_zone = random.choice(['A', 'B', 'C'])

        self.env.process(self.run())

    def run(self):
        for i in range(len(self.stations) - 1):
            current_station = self.stations[i]
            next_station = self.stations[i + 1]

            # Process at the current station
            yield self.env.process(current_station.process(self))

            # Move to the next station using a mover robot
            robot = self.mover_robots.pop(0)  # Get an available robot
            yield self.env.process(robot.move_package(self, current_station, next_station))
            self.mover_robots.append(robot)  # Return the robot to the pool

        # Process at the final station
        yield self.env.process(self.stations[-1].process(self))


class Station:
    def __init__(self, env, name, robot_class, robot_task, num_robots=5, process_time_range=(2, 5), **robot_args):
        self.env = env
        self.name = name
        self.queue = simpy.Resource(env, capacity=1)
        self.process_time_range = process_time_range
        self.robots = [robot_class(env, f"{name}_Robot{i}", **robot_args) for i in range(num_robots)]  # Pool of robots
        self.robot_task = robot_task  # The task method to call (e.g., 'stow', 'pick', etc.)

    def process(self, package):
        with self.queue.request() as request:
            yield request
            delay = random.randint(*self.process_time_range)

            # Assign a robot to handle the package
            robot = self.robots.pop(0)  # Get an available robot
            robot_method = getattr(robot, self.robot_task)  # Dynamically get the correct method
            yield self.env.process(robot_method(package, self))  # Call the appropriate method
            self.robots.append(robot)  # Return the robot to the pool

            # Send package data to AWS
            row_dict = {
                "Timestamp": datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S'),
                "PackageID": package.package_id,
                "Stage": self.name,
                "ProcessingTime": delay,
                "Weight_kg": package.weight_kg,
                "Volume_L": package.volume_liters,
                "Priority": package.priority,
                "DestinationZone": package.destination_zone
            }
            send_to_aws(row_dict)

            return delay


def simulate():
    env = simpy.Environment()
    # Use pod name as simulation identifier instead of random number
    pod_name = os.getenv('HOSTNAME', f'local-{random.randint(1000,9999)}')
    sim_id = f"{SIMULATION_ID}-{pod_name}"
    env.sim_id = sim_id  # Store sim_id in environment for robots to access
    
    print(f"\n=== Starting Simulation {sim_id} ===\n")
    
    # Define stations with their specialized robots and tasks
    stow = Station(env, 'Stow', StowRobot, robot_task='stow', num_robots=5, stow_capacity=10)
    pick = Station(env, 'Pick', PickRobot, robot_task='pick', num_robots=5, pick_accuracy=95)
    pack = Station(env, 'Pack', PackRobot, robot_task='pack', num_robots=5, packing_speed=2)
    ship = Station(env, 'Ship', ShipRobot, robot_task='ship', num_robots=5, shipping_capacity=20)
    stations = [stow, pick, pack, ship]

    # Create a pool of mover robots for inter-station movement
    mover_robots = [MoverRobot(env, f"MoverRobot{i}", speed=5) for i in range(3)]

    print(f"Simulation {sim_id}: Created {len(mover_robots)} mover robots")
    print(f"Simulation {sim_id}: Initializing stations: {', '.join([s.name for s in stations])}")

    # Create packages
    for i in range(1, 11):  # simulate 10 packages
        Package(env, f'P{i}', stations, mover_robots)
        print(f"Simulation {sim_id}: Created package P{i}")

    env.run(until=100)
    print(f"\n=== Simulation {sim_id} complete ===\n")


if __name__ == "__main__":
    print("Simulation started.")
    simulate()

