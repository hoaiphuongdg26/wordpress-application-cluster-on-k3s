# modules/ec2/outputs.tf

output "master_info" {
  description = "Information of the EC2 instance Master"
  value = [for i in aws_instance.master : {
    tag_name   = i.tags.name
    id         = i.id
    public_ip  = i.public_ip
    public_dns = i.public_dns
    private_ip = i.private_ip
    key_name   = i.key_name
  }]
}
output "worker_info" {
  description = "Information of the EC2 instance Worker"
  value = [for i in aws_instance.worker : {
    tag_name   = i.tags.name
    id         = i.id
    public_ip  = i.public_ip
    public_dns = i.public_dns
    private_ip = i.private_ip
    key_name   = i.key_name
  }]
}
