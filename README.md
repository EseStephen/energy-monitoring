# Energy Monitoring Solution
## Overview
A serverless, real-time AWS-native solution to monitor energy consumption from an IoT box in an apartment, with enhancements for security, monitoring, and cost optimization.
## Architecture
- **Flow**: IoT Box → AWS IoT Core → Kinesis Data Streams → AWS Lambda → DynamoDB + S3.
- **Monitoring**: CloudWatch tracks Lambda errors and Kinesis throttling.
- **Diagram**: See `energy-monitoring-architecture.png`.
## Design
### Service Choices
1. **AWS IoT Core**: Secure MQTT ingestion with IoT policy.
2. **Kinesis Data Streams**: Real-time buffering, scalable with shards.
3. **AWS Lambda**: Serverless processing with batching for efficiency.
4. **DynamoDB**: Low-latency storage, encrypted at rest.
5. **S3**: Cost-effective archiving, encrypted with AES256.
6. **CloudWatch**: Monitors performance and alerts on failures.
## Implementation
- **Terraform**: Modular IaC in `main.tf` and `modules/`.
- **Lambda**: Processes batched Kinesis data, stores in DynamoDB/S3 (`lambda_function.py`).
- **Deployment**: `terraform init`, `terraform apply`.
## Security
- **Encryption**: TLS (IoT Core), AES256 (S3), server-side encryption (DynamoDB).
- **IAM**: Least-privilege roles for IoT Core and Lambda.
- **IoT Policy**: Restricts device actions.
## Cost Optimization
- **Serverless**: Lambda and DynamoDB PAY_PER_REQUEST avoid idle costs.
- **Batching**: Lambda batches 100 records or 10 seconds, reducing invocations.
- **S3**: Cheap long-term storage.
## Scalability & Fault Tolerance
- **Kinesis**: Scales with shards.
- **Lambda**: Auto-scales with triggers.
- **DynamoDB/S3**: Multi-AZ, highly available.
## Operational Considerations
- **CloudWatch**: Logs Lambda execution, alarms on errors/throttling.
- **Alerts**: Configurable via SNS (not implemented).
## Bonus: Data Batching
- **Implementation**: Lambda `batch_size = 100`, `maximum_batching_window_in_seconds = 10`.
- **Benefit**: Fewer invocations, lower costs (~10s latency trade-off).
## Setup
1. Configure AWS credentials (`aws configure`).
2. Run `terraform init`, `terraform apply`.