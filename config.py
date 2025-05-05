import os
from dotenv import load_dotenv
import uuid

load_dotenv()

AWS_REGION = os.getenv('AWS_REGION', 'us-west-2')
KINESIS_STREAM_NAME = os.getenv('KINESIS_STREAM_NAME', 'robotics-sim-stream')
SIMULATION_ID = os.getenv('SIMULATION_ID', f'sim-{uuid.uuid4()}')
