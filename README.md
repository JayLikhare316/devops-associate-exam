# DevOps Associate Practical Exam

This repository contains the solution for the DevOps Associate Practical Exam, demonstrating skills in Terraform, Docker Compose, and AWS monitoring.

## Project Structure

```
.
├── .github/workflows/
│   └── ci.yml                # GitHub Actions CI workflow
├── s3.tf                     # Terraform configuration for S3 bucket
├── ec2.tf                    # Terraform configuration for EC2 instance
├── docker-compose.yml        # Docker Compose configuration with web, redis, and ELK stack
├── logstash.conf             # Logstash configuration for log aggregation
├── cloudwatch_alarm.sh       # AWS CLI script for CloudWatch alarm
├── prometheus.yml            # Prometheus configuration for monitoring
└── README.md                 # This file
```

## Prerequisites

- AWS CLI installed and configured
- Terraform installed (v1.0.0 or later)
- Docker and Docker Compose installed
- Git installed

## Step 1: AWS Configuration

Configure your AWS credentials:

```bash
aws configure
```

Enter your AWS Access Key ID, Secret Access Key, default region (e.g., us-east-1), and output format (json).

## Step 2: Terraform Infrastructure Provisioning

Initialize Terraform:

```bash
terraform init
```

Review the planned changes:

```bash
terraform plan
```

Apply the Terraform configuration to create the S3 bucket and EC2 instance:

```bash
terraform apply
```

When prompted, type `yes` to confirm.

After successful application, note the EC2 instance's public IP address from the output:

```
Outputs:
public_ip = "X.X.X.X"
```

## Step 3: Update Monitoring Configurations

### Update Prometheus Configuration

Replace `X.X.X.X` in `prometheus.yml` with your actual EC2 instance public IP:

```bash
sed -i 's/X.X.X.X/YOUR_ACTUAL_IP/' prometheus.yml
```

### Update CloudWatch Alarm Script

Get your EC2 instance ID:

```bash
INSTANCE_ID=$(terraform output -raw instance_id)
```

Update the CloudWatch alarm script with your instance ID:

```bash
sed -i "s/i-0123456789abcdef0/$INSTANCE_ID/" cloudwatch_alarm.sh
```

Make the script executable:

```bash
chmod +x cloudwatch_alarm.sh
```

## Step 4: Create CloudWatch Alarm

Run the CloudWatch alarm script:

```bash
./cloudwatch_alarm.sh
```

## Step 5: Run Docker Compose

Start the containers:

```bash
docker-compose up -d
```

Verify the services are running:

```bash
docker-compose ps
```

## Step 6: Access Services

- Web application: http://localhost:8080
- Kibana dashboard: http://localhost:5601

## Step 7: Testing Log Aggregation

Generate some logs for testing:

```bash
echo "$(date) - Test log entry" >> /var/log/app.log
```

Check Kibana to verify logs are being collected.

## Step 8: Verify Container Health

Check the health status of containers:

```bash
docker-compose ps
docker inspect --format='{{.State.Health.Status}}' $(docker-compose ps -q web)
```

## Step 9: Clean Up Resources

When you're done testing, clean up all resources to avoid ongoing charges:

1. Stop and remove Docker containers:

```bash
docker-compose down
```

2. Destroy AWS resources:

```bash
terraform destroy
```

When prompted, type `yes` to confirm.

## CI/CD Pipeline

The GitHub Actions workflow in `.github/workflows/ci.yml` automatically validates Terraform configurations when code is pushed to the main branch or when a pull request is created.

## Notes

- All AWS resources are tagged with `Environment = "DevOpsTest"` for easy identification and cleanup.
- The ELK stack is configured to collect logs from `/var/log/app.log`.
- The CloudWatch alarm triggers when CPU utilization exceeds 80% for 5 consecutive minutes.
- Prometheus is configured to scrape metrics from the EC2 instance every 15 seconds.
