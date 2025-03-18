resource "aws_lambda_function" "processor" {
 function_name = var.function_name
 handler       = "lambda_function.handler"
 runtime       = "python3.9"
 filename      = "lambda_function.zip"
 role          = aws_iam_role.lambda_role.arn
}
resource "aws_iam_role" "lambda_role" {
 name = "${var.function_name}-role"
 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [{
     Action    = "sts:AssumeRole"
     Effect    = "Allow"
     Principal = { Service = "lambda.amazonaws.com" }
   }]
 })
}
resource "aws_iam_role_policy" "lambda_policy" {
 name   = "${var.function_name}-policy"
 role   = aws_iam_role.lambda_role.id
 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Effect   = "Allow"
       Action   = ["kinesis:DescribeStream", "kinesis:GetRecords", "kinesis:GetShardIterator"]
       Resource = var.kinesis_arn
     },
     {
       Effect   = "Allow"
       Action   = ["dynamodb:PutItem"]
       Resource = "arn:aws:dynamodb:*:*:table/energy-consumption"
     },
     {
       Effect   = "Allow"
       Action   = ["s3:PutObject"]
       Resource = "arn:aws:s3:::energy-data-archive-${var.account_id}/*"
     },
     {
       Effect   = "Allow"
       Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
       Resource = "*"
     }
   ]
 })
}
resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
 event_source_arn  = var.kinesis_arn
 function_name     = aws_lambda_function.processor.arn
 starting_position = "LATEST"
 batch_size        = 100    # Bonus: Batching for cost optimization
 maximum_batching_window_in_seconds = 10  # Batch up to 10 seconds
}
output "function_arn" {
 value = aws_lambda_function.processor.arn
}