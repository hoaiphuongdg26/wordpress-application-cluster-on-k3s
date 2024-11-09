# aws-terraform-infrastructure/instances.tf
# Create Management Server (Bastion Host/Jenkins/HAProxy)
module "management_server" {
  source = "./modules/ec2"
  name            = "management-server"
  subnets_id      = [module.vpc.public_subnets[0]]
  sgs_id          = [module.management_sg.id]
  key_name        = module.keypair.key_name
  instance_type   = var.aws_instance_config.management_instance_type
  instance_count  = var.aws_instance_config.management_instance_count
  private_ips     = var.aws_instance_config.management_private_ips
}

module "eip-management_server" {
  source = "./modules/eip"
  name             = "public-app"
  instance_ids     = module.management_server.instance_ids
  internet_gateway = module.vpc.internet_gateway_id
  create_eip       = true
}

# Create Kubernetes Master Node (Master Node/NFS Server/Monitoring Stack (Prometheus/Grafana))
module "k8s_masters" {
  source = "./modules/ec2"
  name            = "k8s-masters"
  subnets_id      = [module.vpc.private_subnets[0]]
  sgs_id          = [module.k8s_masters_sg.id]
  key_name        = module.keypair.key_name
  instance_type   = var.aws_instance_config.cluster_instance_type
  instance_count  = var.aws_instance_config.k8s_master_instance_count
  private_ips     = var.aws_instance_config.k8s_master_private_ips
}

# Create Kubernetes Worker Nodes
module "k8s_workers" {
  source = "./modules/ec2"
  name            = "k8s-workers"
  subnets_id      = [module.vpc.private_subnets[0]]
  sgs_id          = [module.k8s_workers_sg.id]
  key_name        = module.keypair.key_name
  instance_type   = var.aws_instance_config.cluster_instance_type
  instance_count  = var.aws_instance_config.k8s_workers_instance_count
  private_ips     = var.aws_instance_config.k8s_worker_private_ips
}