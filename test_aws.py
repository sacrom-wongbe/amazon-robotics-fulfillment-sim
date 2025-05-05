import boto3
import json
from config import AWS_REGION, KINESIS_STREAM_NAME, SIMULATION_ID

def test_aws_connection():
    print("🔍 Running AWS Connection Tests...")
    
    try:
        # 1. Test AWS credentials
        sts = boto3.client('sts')
        identity = sts.get_caller_identity()
        print(f"\n✅ AWS Credentials Valid")
        print(f"Account: {identity['Account']}")
        print(f"User: {identity['UserId']}")
        
        # 2. Test Kinesis connection and stream status
        kinesis_client = boto3.client('kinesis', region_name=AWS_REGION)
        response = kinesis_client.describe_stream(StreamName=KINESIS_STREAM_NAME)
        print(f"\n✅ Kinesis Stream Found")
        print(f"Stream Status: {response['StreamDescription']['StreamStatus']}")
        print(f"Shards: {len(response['StreamDescription']['Shards'])}")
        
        # 3. Test sending a sample message (using proper JSON encoding)
        test_data = {
            "test": "Hello AWS!",
            "timestamp": "2025-05-02",
            "simulation_id": SIMULATION_ID
        }
        
        response = kinesis_client.put_record(
            StreamName=KINESIS_STREAM_NAME,
            Data=json.dumps(test_data).encode('utf-8'),
            PartitionKey='test'
        )
        print(f"\n✅ Successfully sent test message")
        print(f"Sequence number: {response['SequenceNumber']}")
        print(f"Shard ID: {response['ShardId']}")
        
    except Exception as e:
        print(f"\n❌ Test failed: {str(e)}")
        if 'ExpiredToken' in str(e):
            print("Solution: Your AWS credentials have expired. Run 'aws configure' again.")
        elif 'ResourceNotFoundException' in str(e):
            print(f"Solution: Kinesis stream '{KINESIS_STREAM_NAME}' not found. Create it with:")
            print(f"aws kinesis create-stream --stream-name {KINESIS_STREAM_NAME} --shard-count 1")

if __name__ == "__main__":
    test_aws_connection()