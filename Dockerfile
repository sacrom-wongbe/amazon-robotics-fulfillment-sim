FROM python:3.9-slim

WORKDIR /app

# Copy only requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy only the specific files needed
COPY amazon-robotics-fulfillment-sim.py .
COPY config.py .

# Add labels for better tracking
LABEL maintainer="Your Name"
LABEL version="1.0"
LABEL description="Amazon Robotics Fulfillment Simulation"

CMD ["python", "amazon-robotics-fulfillment-sim.py"]
