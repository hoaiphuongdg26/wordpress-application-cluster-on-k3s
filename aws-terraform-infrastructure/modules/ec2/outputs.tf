# modules/ec2/outputs.tf

output "master_info" {
  description = "Information of the EC2 instance Master"
  value = [for i in range(length(aws_instance.master)) : {
    tag_name    = aws_instance.master[i].tags.name
    id          = aws_instance.master[i].id
    public_dns  = aws_eip.master_eip[i].public_dns
    private_ip  = aws_instance.master[i].private_ip
    key_name    = aws_instance.master[i].key_name
    elastic_ip  = aws_eip.master_eip[i].public_ip
  }]
}

output "worker_info" {
  description = "Information of the EC2 instance Worker"
  value = [for i in range(length(aws_instance.worker)) : {
    tag_name    = aws_instance.worker[i].tags.name
    id          = aws_instance.worker[i].id
    public_dns  = aws_eip.worker_eip[i].public_dns
    private_ip  = aws_instance.worker[i].private_ip
    key_name    = aws_instance.worker[i].key_name
    elastic_ip  = aws_eip.worker_eip[i].public_ip
  }]
}