output "s3_bucket_name" {
 description = "Name of the S3 bucket"
 value = module.s3.bucket_name
}
output "dynamodb_table_name" {
 description = "Name of the DynamoDB table"
 value = module.dynamodb.table_name
}
output "lambda_function_arn" {
 value = module.lambda.function_arn
}