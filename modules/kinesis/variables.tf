variable "stream_name" {
 description = "Name of the Kinesis stream"
}
variable "shard_count" {
 description = "Number of shards for the Kinesis stream"
 default     = 1
}