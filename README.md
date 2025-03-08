# Serverless File Processing with S3, Lambda & DynamoDB
![Screenshot 2025-03-09 025958](https://github.com/user-attachments/assets/43c6721a-c27b-4fc7-975c-c05a6ed05dc2)

## Overview


This project automates file processing using AWS serverless technologies. When a file is uploaded to an S3 bucket, an AWS Lambda function is triggered to process the file and store its metadata in DynamoDB.

## Architecture

- **Amazon S3**: Stores uploaded files.
- **AWS Lambda**: Processes files when they are uploaded.
- **Amazon DynamoDB**: Stores metadata about processed files.
- **IAM Role & Policies**: Provides necessary permissions to Lambda.
- **Terraform**: Infrastructure as Code (IaC) for seamless deployment.

## Prerequisites

- AWS Account
- Terraform Installed (>=1.0.0)
- AWS CLI Configured
- Python 3.9

## Deployment

1. Clone the Repository
```
git clone <your-repo-url>
cd serverless-file-processing
```
2. Initialize Terraform
```
cd terraform
terraform init
```
3. Deploy Infrastructure
```
terraform apply -auto-approve
```
4. Upload a Test File to S3
```
aws s3 cp test-file.txt s3://your-bucket-name/
```
5. Verify the Entry in DynamoDB
```
Go to AWS DynamoDB Console → Tables → FileMetadata → Explore Table to check if metadata was stored.
```
6. Cleanup
```
terraform destroy -auto-approve
```
## Future Enhancements

- Add logging & monitoring with AWS CloudWatch.
- Implement file validation & categorization.
- Use Step Functions for complex processing workflows.

# Contributors
Ali H. Mughal (AWS. Solutions Architect)
