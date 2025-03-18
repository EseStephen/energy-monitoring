resource "aws_dynamodb_table" "energy_table" {
 name           = var.table_name
 billing_mode   = "PAY_PER_REQUEST"
 hash_key       = "timestamp"
 server_side_encryption {
   enabled = true  # Enhanced security
 }
 attribute {
   name = "timestamp"
   type = "S"
 }
}
output "table_name" {
 value = aws_dynamodb_table.energy_table.name
}