import json
import base64
import boto3
import time
dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')
table = dynamodb.Table('energy-consumption')
bucket = f"energy-data-archive-{time.strftime('%Y%m%d')}"
def handler(event, context):
   """
   Process batched Kinesis records, store in DynamoDB, and archive raw data in S3.
   """
   for record in event['Records']:
       # Decode Kinesis data
       payload = base64.b64decode(record['kinesis']['data']).decode('utf-8')
       data = json.loads(payload)
       # Extract and process data
       timestamp = data.get('timestamp', time.strftime('%Y-%m-%dT%H:%M:%S'))
       energy_usage = float(data.get('energy_usage', 0))
       # Store in DynamoDB
       table.put_item(
           Item={
               'timestamp': timestamp,
               'energy_usage': str(energy_usage)
           }
       )
       # Archive raw data in S3
       s3.put_object(
           Bucket=bucket,
           Key=f"raw/{timestamp}.json",
           Body=payload
       )
   return {
       'statusCode': 200,
       'body': json.dumps(f"Processed {len(event['Records'])} records")
   }