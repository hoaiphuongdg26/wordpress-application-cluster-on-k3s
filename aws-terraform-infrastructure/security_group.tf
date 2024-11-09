# Create a security group for management server
module "management_sg" {
  source      = "./modules/security_group"
  name        = "management-sg"
  description = "Security group for management server"
  vpc_id      = module.vpc.vpc_id

  ingress_rules_with_cidr = [
    {
      description = "Allow OpenVPN Access"
      from_port   = 1194
      to_port     = 1194
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow SSH Access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow HTTP Access"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow HTTPS Access"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow Jenkins Access"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      ip          = "0.0.0.0/0"
    },
    {
      description = "Allow traffic from VPN subnet"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      ip          = "172.16.0.0/24"
    },
  ]

  egress_rules_with_cidr = [
    {
      description = "Allow all outbound traffic"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      ip          = "0.0.0.0/0"
    }
  ]
}

# Create a security group for Kubernetes Master Node
module "k8s_masters_sg" {
  source      = "./modules/security_group"
  name        = "k8s-master-sg"
  description = "Security group for Kubernetes Master Node"
  vpc_id      = module.vpc.vpc_id

  ingress_rules_with_security_group = [
    {
      description = "Allow SSH Access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      security_group_id = module.management_sg.id
    },
    {
      description = "Kubernetes API Server Access"
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      security_group_id = module.k8s_workers_sg.id
    },
    {
      description = "etcd Server Access"
      from_port   = 2379
      to_port     = 2379
      protocol    = "tcp"
      security_group_id = module.management_sg.id
    },
    {
      description = "Kubernetes API Server Access"
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      security_group_id = module.k8s_workers_sg.id
    },
    {
      description = "NFS Server Access"
      from_port   = 2049
      to_port     = 2049
      protocol    = "tcp"
      security_group_id = module.management_sg.id
    },
    {
      description = "Flannel Access"
      from_port   = 8472
      to_port     = 8472
      protocol    = "udp"
      security_group_id = module.management_sg.id
    },
    {
      description = "Allow all traffic from workers"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      security_group_id = module.k8s_workers_sg.id
    }
  ]
  ingress_rules_with_cidr = [
    {
      description = "Allow traffic from VPN subnet"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      ip          = "172.16.0.0/24"
    },
  ]
  egress_rules_with_cidr = [
    {
      description = "Allow all outbound traffic"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      ip          = "0.0.0.0/0"
    }
  ]
}

module "k8s_workers_sg" {
  source      = "./modules/security_group"
  name        = "k8s-workers-sg"
  description = "Security group for Kubernetes Worker Nodes"
  vpc_id      = module.vpc.vpc_id

  ingress_rules_with_security_group = [
    {
      description = "Allow SSH Access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      security_group_id = module.management_sg.id
    },
    {
      description = "Kubernetes API Server Access"
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      security_group_id = module.management_sg.id
    },
    {
      description = "NodePort Access"
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      security_group_id = module.management_sg.id
    },
    {
      description = "Allow all traffic from master"
      from_port   = -1
      to_port     = -1
      protocol    = -1
      security_group_id = module.k8s_masters_sg.id
    },
    {
      description = "Allow all traffic from other workers"
      from_port   = -1
      to_port     = -1
      protocol    = -1
      security_group_id = module.k8s_workers_sg.id
    }
  ]
  ingress_rules_with_cidr = [
    {
      description = "Allow traffic from VPN subnet"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      ip          = "172.16.0.0/24"
    },
  ]
  egress_rules_with_cidr = [
    {
      description = "Allow all outbound traffic"
      from_port   = -1
      to_port     = -1
      protocol    = "-1"
      ip          = "0.0.0.0/0"
    }
  ]
}