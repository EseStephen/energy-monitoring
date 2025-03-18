variable "lambda_arn" {
  description = "ARN of the Lambda function"
}

variable "kinesis_arn" {
  description = "ARN of the Kinesis stream"
}

variable "lambda_name" {
  description = "Name of the Lambda function"
  default     = "energy-processor"
}

variable "kinesis_name" {
  description = "Name of the Kinesis stream"
  default     = "energy-data-stream"
}