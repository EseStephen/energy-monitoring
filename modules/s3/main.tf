resource "aws_s3_bucket" "archive" {
 bucket = var.bucket_name
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
 bucket = aws_s3_bucket.archive.bucket
 rule {
   apply_server_side_encryption_by_default {
     sse_algorithm = "AES256"
   }
 }
}
output "bucket_name" {
 value = aws_s3_bucket.archive.bucket
}