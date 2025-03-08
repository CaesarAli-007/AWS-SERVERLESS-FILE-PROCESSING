#!/bin/bash

# Set variables
BUCKET_NAME="serverless-file-processing-1007"
TABLE_NAME="FileMetadata"
LAMBDA_FUNCTION_NAME="fileProcessorLambda"
IAM_ROLE_NAME="LambdaFileProcessingRole"
ZIP_FILE="lambda_function.zip"
LAMBDA_HANDLER="lambda_function.lambda_handler"
LAMBDA_RUNTIME="python3.9"
REGION="us-east-1"  # Change to your preferred AWS region

echo "🚀 Starting deployment..."

# Step 1: Create S3 Bucket
echo "📂 Creating S3 Bucket: $BUCKET_NAME..."
aws s3 mb s3://$BUCKET_NAME --region $REGION

# Step 2: Create DynamoDB Table
echo "📄 Creating DynamoDB Table: $TABLE_NAME..."
aws dynamodb create-table \
    --table-name $TABLE_NAME \
    --attribute-definitions AttributeName=file_name,AttributeType=S \
    --key-schema AttributeName=file_name,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region $REGION

# Step 3: Create IAM Role for Lambda
echo "🔑 Creating IAM Role: $IAM_ROLE_NAME..."
aws iam create-role \
    --role-name $IAM_ROLE_NAME \
    --assume-role-policy-document file://infrastructure/iam_policies.json \
    --region $REGION

# Attach policies to IAM Role
aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AWSLambdaBasicExecutionRole
aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
aws iam attach-role-policy --role-name $IAM_ROLE_NAME --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess

# Step 4: Package Lambda Function
echo "📦 Packaging Lambda function..."
zip -r $ZIP_FILE lambda_function.py

# Step 5: Create Lambda Function
echo "🖥️ Deploying Lambda function: $LAMBDA_FUNCTION_NAME..."
aws lambda create-function \
    --function-name $LAMBDA_FUNCTION_NAME \
    --runtime $LAMBDA_RUNTIME \
    --role arn:aws:iam::$(aws sts get-caller-identity --query "Account" --output text):role/$IAM_ROLE_NAME \
    --handler $LAMBDA_HANDLER \
    --zip-file fileb://$ZIP_FILE \
    --region $REGION

# Step 6: Configure S3 Event Trigger for Lambda
echo "🔄 Adding S3 trigger to Lambda..."
aws lambda add-permission \
    --function-name $LAMBDA_FUNCTION_NAME \
    --statement-id s3-trigger \
    --action "lambda:InvokeFunction" \
    --principal s3.amazonaws.com \
    --source-arn arn:aws:s3:::$BUCKET_NAME \
    --region $REGION

aws s3api put-bucket-notification-configuration \
    --bucket $BUCKET_NAME \
    --notification-configuration '{
        "LambdaFunctionConfigurations": [{
            "LambdaFunctionArn": "arn:aws:lambda:'$REGION':'$(aws sts get-caller-identity --query "Account" --output text)':function:'$LAMBDA_FUNCTION_NAME'",
            "Events": ["s3:ObjectCreated:*"]
        }]
    }' \
    --region $REGION

echo "✅ Deployment complete! Your serverless file processing system is live."

#  How to Use
#  1) Ensure you have AWS CLI installed and configured (aws configure).
#  2) Make the script executable
#       "chmod +x deploy.sh"
#  3) Run the script
#       ""./deploy.sh"

