# Output for Public EC2 Instances
output "instance_ips" {
  description = "Instance IPs"
  value = {
    for i in aws_instance.this :
    i.id => {
      name       = i.tags["Name"]
      private_ip = i.private_ip
    }
  }
}
output "instance_ids" {
  value = aws_instance.this[*].id
}