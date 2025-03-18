variable "region" {
 description = "AWS region for deployment" 
 default     = "us-east-1" #this can be changed according to requirement
}
variable "account_id" {
 description = "AWS account ID for unique naming"
 default     = "123456789012"  # Replace this with your AWS account ID
}