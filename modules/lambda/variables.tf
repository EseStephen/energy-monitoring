variable "function_name" {
 description = "Name of the Lambda function"
}
variable "kinesis_arn" {
 description = "ARN of the Kinesis stream"
}
variable "account_id" {
 description = "AWS account ID for S3 ARN"
 default     = "123456789012"
}