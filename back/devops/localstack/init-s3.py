import boto3
import json

s3_client = boto3.client(
  "s3",
  endpoint_url="http://localhost:4566",
  aws_access_key_id="test",
  aws_secret_access_key="test",
  region_name="us-east-1"
)

s3_client.create_bucket(Bucket="ai4cod")

s3_client.put_bucket_policy(
  Bucket="ai4cod",
  Policy=json.dumps(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "LimitUploadSize",
          "Effect": "Deny",
          "Principal": "*",
          "Action": "s3:PutObject",
          "Resource": "arn:aws:s3:::ai4cod/*",
          "Condition": {
            "NumericGreaterThan": {
              "s3:content-length-range": 1024 * 1024 * 1
            }
          }
        }
      ]
    }
  )
)
