## How to access ECS infrastructure EC2 instances via SSH?

Download the ".pem" files from S3 "https://us-east-2.console.aws.amazon.com/s3/buckets/ai4cod?region=us-east-2&bucketType=general&prefix=keypairs/&showversions=false"
Create the "devops/tmp/keypairs" folder
Save the ".pem" files inside the "devops/tmp/keypairs" folder

### Production

```sh
cd ai4cod/back
  chmod 400 "devops/tmp/keypairs/production.pem"
  ./devops/ecs/ssh_production.sh
```
Copy and paste the 2 commands that appear at the top of the output when entering the EC2 instance
