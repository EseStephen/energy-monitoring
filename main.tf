provider "aws" {
 region = var.region
}
# IAM Role for IoT Core to access Kinesis
resource "aws_iam_role" "iot_role" {
 name = "iot-to-kinesis-role"
 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [{
     Action    = "sts:AssumeRole"
     Effect    = "Allow"
     Principal = { Service = "iot.amazonaws.com" }
   }]
 })
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"  # Use a known version
    }
  }
}
resource "aws_iam_role_policy" "iot_policy" {
 name   = "iot-kinesis-policy"
 role   = aws_iam_role.iot_role.id
 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Effect   = "Allow"
       Action   = ["kinesis:PutRecord"]
       Resource = module.kinesis.stream_arn
     }
   ]
 })
}
module "iot_core" {
 source     = "./modules/iot_core"
 thing_name = "apartment_iot_box"
}
module "kinesis" {
 source      = "./modules/kinesis"
 stream_name = "energy-data-stream"
}
module "lambda" {
 source        = "./modules/lambda"
 function_name = "energy-processor"
 kinesis_arn   = module.kinesis.stream_arn
}
module "dynamodb" {
 source     = "./modules/dynamodb"
 table_name = "energy-consumption"
}
module "s3" {
 source      = "./modules/s3"
 bucket_name = "energy-data-archive-${var.account_id}"
}
module "cloudwatch" {
 source         = "./modules/cloudwatch"
 lambda_arn     = module.lambda.function_arn
 kinesis_arn    = module.kinesis.stream_arn
}
# IoT Rule to forward data to Kinesis
resource "aws_iot_topic_rule" "kinesis_rule" {
  name         = "iot_to_kinesis"
  sql          = "SELECT * FROM 'energy/#'"
  sql_version  = "2016-03-23"  # Stable version
  enabled      = true
  kinesis {
    stream_name = module.kinesis.stream_name
    role_arn    = aws_iam_role.iot_role.arn
  }
}