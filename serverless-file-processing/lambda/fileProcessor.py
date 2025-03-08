import json
import boto3
import os
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')

table_name = "<Your Table Name>"  # DynamoDB Table Name
bucket_name = "<Your Bucket Name>"  # S3 Bucket Name
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    try:
        for record in event['Records']:
            bucket = record['s3']['bucket']['name']
            file_key = record['s3']['object']['key']
            file_size = record['s3']['object']['size']
            upload_time = datetime.utcnow().isoformat()

            # Store metadata in DynamoDB
            table.put_item(
                Item={
                    'file_key': file_key,
                    'bucket': bucket,
                    'file_size': file_size,
                    'upload_time': upload_time
                }
            )

        return {
            'statusCode': 200,
            'body': json.dumps('File metadata stored successfully!')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
