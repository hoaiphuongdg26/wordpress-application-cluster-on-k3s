output "instances" {
  value = {
    management_server = [
      for instance in aws_instance.management_server : {
        id = instance.id,
        public_ip = instance.public_ip,
        private_ip = instance.private_ip,
        public_dns = instance.public_dns,
        tags = instance.tags,
      }
    ],

    management_eip = module.eip-management_server.public_ips

    k3s_master = [
      for instance in aws_instance.k8s_masters : {
        id = instance.id,
        public_ip = instance.public_ip,
        private_ip = instance.private_ip,
        public_dns = instance.public_dns,
        tags = instance.tags,
      }
    ],
    k3s_worker = [
      for instance in aws_instance.k8s_workers : {
        id = instance.id,
        public_ip = instance.public_ip,
        private_ip = instance.private_ip,
        public_dns = instance.public_dns,
        tags = instance.tags,
      }
    ],
  }
}

output "key_path" {
  value = module.keypair.private_key_path
}