resource "aws_kinesis_stream" "energy_stream" {
 name        = var.stream_name
 shard_count = var.shard_count
}
output "stream_arn" {
 value = aws_kinesis_stream.energy_stream.arn
}
output "stream_name" {
 value = aws_kinesis_stream.energy_stream.name
}