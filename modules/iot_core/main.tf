resource "aws_iot_thing" "iot_device" {
 name = var.thing_name
}
resource "aws_iot_policy" "iot_policy" {
 name   = "${var.thing_name}-policy"
 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [{
     Effect   = "Allow"
     Action   = ["iot:Connect", "iot:Publish"]
     Resource = ["*"]
   }]
 })
}