# Amazon Robotics Fulfillment Simulator

## Docker Commands

Build and push the simulator image:
```powershell
# Build Docker image
docker build -t robotics-sim .

# Tag image for ECR
docker tag robotics-sim 805791260265.dkr.ecr.us-west-2.amazonaws.com/robotics-sim:latest

# Login to ECR
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 805791260265.dkr.ecr.us-west-2.amazonaws.com

# Push to ECR
docker push 805791260265.dkr.ecr.us-west-2.amazonaws.com/robotics-sim:latest
```

## Kubernetes Commands

Job management:
```powershell
# Apply the job
kubectl apply -f k8s/job.yaml

# Delete existing job
kubectl delete job robotics-sim-job -n robotics-sim

# Watch pods
kubectl get pods -n robotics-sim -w
```

Pod monitoring:
```powershell
# Get all pods with status
kubectl get pods -n robotics-sim

# Get pod logs (replace POD_NAME with actual pod name)
kubectl logs -n robotics-sim POD_NAME

# Get logs from all pods with app label
kubectl logs -n robotics-sim -l app=robotics-sim

# Describe pod details
kubectl describe pod -n robotics-sim POD_NAME
```

Common flags:
- `-n`: Specify namespace
- `-l`: Filter by label
- `-w`: Watch for changes
- `-f`: Follow logs in real-time
- `--previous`: Get logs from previous pod instance

## AWS Commands

```powershell
# List S3 CSV files
aws s3 ls s3://robotics-sim-data-805791260265-us-west-2-csved/csv/year=2025/month=05/day=10/ --recursive

# Get Kinesis stream records
aws kinesis get-records --shard-iterator $(aws kinesis get-shard-iterator --stream-name robotics-sim-stream --shard-id 0 --shard-iterator-type TRIM_HORIZON --query 'ShardIterator' --output text)
```