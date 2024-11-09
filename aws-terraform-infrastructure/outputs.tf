output "instances" {
  value = [
    module.management_server,
    module.eip-management_server,
    module.k8s_masters,
    module.k8s_workers
  ]
}

output "key_path" {
  value = module.keypair.private_key_path
}