# S3 Bucket Configuration for File Processing

## 1️⃣ Create an S3 Bucket
1. Navigate to **Amazon S3**.
2. Click **Create bucket**.
3. Set **Bucket Name**: `your-bucket-name`.
4. Choose a **Region** (keep it the same as your Lambda function).
5. **Block Public Access**: Keep all options **enabled**.
6. Click **Create bucket**.

## 2️⃣ Enable Event Notifications for S3 → Lambda
1. Open the created bucket and go to **Properties**.
2. Scroll to **Event Notifications** → Click **Create event notification**.
3. **Event Name**: `LambdaTriggerEvent`
4. **Prefix/Suffix**: (Optional, for filtering specific file types)
5. **Event Type**: Select **PUT**.
6. **Destination**: Choose **Lambda Function** and select `fileProcessorLambda`.
7. Click **Save Changes**.

Your S3 bucket is now configured to trigger the Lambda function upon file uploads.
