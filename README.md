# Applicaiton with K3S
This project utilizes Terraform to deploy AWS infrastructure, which consists of a primary VPC with a public subnet housing two instances: a master and a worker. 

Subsequently, Ansible is employed to install the k3s cluster environment and HAProxy to deploy a WordPress application cluster with MySQL replication services, along with TLS/SSL and an NGINX controller

This project aims to utilize Terraform and Ansible to deploy a basic web application, without delving into security and safety issues.
## Table of Contents

- [Applicaiton with K3S](#applicaiton-with-k3s)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Architecture](#architecture)
    - [1. Terraform](#1-terraform)
    - [2. Cluster](#2-cluster)
  - [Deployment Steps](#deployment-steps)
    - [1. Set Up the Infrastructure](#1-set-up-the-infrastructure)
    - [2. Install K3s](#2-install-k3s)
  
## Prerequisites
Before you begin, ensure you have the following:

## Architecture
### 1. Terraform
- **VPC** with public subnets.
- **Internet Gateway** for public subnets.
- **Security groups** for controlling access.
- **EC2 instances** in public subnets.
- **Keypair** for each EC2 instances.
### 2. Cluster
- **K3s**: A lightweight Kubernetes distribution.
- **MySQL Replication**: For database redundancy and high availability.
- **HAProxy**: To manage incoming traffic and load balance requests.
- **NGINX Ingress**: To route external traffic to the appropriate services within the cluster.
  
## Deployment Steps
### 1. Set Up the Infrastructure 
   Use Terraform to create the necessary infrastructure, including the VPC and VMs.

   ```bash
   cd terraform/
   terraform init
   terraform plan
   terraform apply
   ```
### 2. Install K3s
   Use Ansible to install K3s on the master and worker nodes.
   ```bash
   cd ../ansible/
   ansible-playbook site.yml
   ```
