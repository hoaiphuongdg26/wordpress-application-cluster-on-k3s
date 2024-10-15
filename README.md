# WordPress Application Cluster on K3s

This project demonstrates deploying a scalable WordPress application cluster using K3s, a lightweight Kubernetes distribution, on AWS infrastructure. It utilizes Terraform for infrastructure provisioning and Ansible for configuration management and application deployment.

## Table of Contents

- [WordPress Application Cluster on K3s](#wordpress-application-cluster-on-k3s)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
  - [Architecture](#architecture)
    - [Model](#model)
    - [Infrastructure (AWS)](#infrastructure-aws)
    - [Application Stack](#application-stack)
  - [Prerequisites](#prerequisites)
  - [Deployment Steps](#deployment-steps)
    - [1. Set Up AWS Infrastructure](#1-set-up-aws-infrastructure)
    - [2. Configure Ansible Inventory](#2-configure-ansible-inventory)
    - [3. Create Secret for cluster](#3-create-secret-for-cluster)
    - [4. Install Required Ansible Collections](#4-install-required-ansible-collections)
    - [5. Deploy K3s Cluster and Applications](#5-deploy-k3s-cluster-and-applications)
  - [Components Explained](#components-explained)
  - [Security Considerations](#security-considerations)
  - [Enhancements](#enhancements)
  - [References](#references)

## Project Overview

This project aims to create a robust, scalable WordPress deployment using modern DevOps practices and tools. It leverages:

- Terraform for infrastructure as code (IaC)
- Ansible for configuration management and application deployment
- K3s for a lightweight Kubernetes environment
- HAProxy for load balancing
- MySQL with replication for data persistence
- NGINX Ingress Controller for routing

The result is a WordPress cluster that can handle high traffic loads and provides improved reliability through component redundancy.

## Architecture

### Model
<img src="./image/Diagram.svg" alt="Description"/>

### Infrastructure (AWS)

- VPC with public subnets
- Internet Gateway for public internet access
- Security groups for access control
- EC2 instances (1 master, 1 worker) in public subnets
- Elastic IPs for stable public addressing

### Application Stack

- **Load Balancer Layer**: HAProxy for distributing incoming traffic
- **Application Layer**: WordPress deployments running on K3s
- **Data Layer**: MySQL StatefulSet with primary-replica replication
- **Storage**: NFS Server for shared filesystem (WordPress media, etc.)
- **Ingress**: NGINX Ingress Controller for routing and SSL termination

## Prerequisites

Before you begin, ensure you have the following installed:

- AWS CLI configured with appropriate credentials
- Terraform (version 0.14+)
- Ansible (version 2.9+)

## Deployment Steps

### 1. Set Up AWS Infrastructure

```bash
cd aws-terraform-infrastructure/
terraform init
terraform plan
terraform apply
```
Take note of the output values, as they'll be needed for Ansible configuration.

### 2. Configure Ansible Inventory
Update the `./inventory/hosts.yml` file with the information from Terraform output:
```yaml
all:
  children:
    k3s_cluster:
      children:
        master:
          hosts:
            dev-master-1:
              ansible_host: <elastic_ip>
              private_ip: <private_ip>
              dns_name: <public_dns>
              ansible_ssh_private_key_file: ../aws-terraform-infrastructure/keys/dev-master-1.pem
        worker:
          hosts:
            dev-worker-1:
              ansible_host: <elastic_ip>
              private_ip: <private_ip>
              ansible_ssh_private_key_file: ../aws-terraform-infrastructure/keys/dev-worker-1.pem
```
### 3. Create Secret for cluster
Create the `./ansible/roles/cluster/tasks/02-secret.yml` file with the example information:
```yaml
# roles/cluster/tasks/02-secret.yml
---
- name: Create MySQL Secret
  k8s:
    state: present
    definition:
      apiVersion: v1
      kind: Secret
      metadata:
        name: mysql-secret
        namespace: default
      type: Opaque
      data:
        MYSQL_ROOT_PASSWORD: MTIzNDU2QFph   # Base64 encoding: 123456@Za
        MYSQL_PASSWORD: MTIzNDU2QFph        # Base64 encoding: 123456@Za
        MYSQL_PASS_SLAVE: MTIzNDU2QFph      # Base64 encoding: 123456@Za
```

### 4. Install Required Ansible Collections
```bash
ansible-galaxy collection install community.general
```

### 5. Deploy K3s Cluster and Applications
```bash
cd ../ansible/
ansible-playbook site.yml
```
This playbook will:
- Install K3s on master and worker nodes
- Deploy HAProxy load balancer
- Set up MySQL replication
- Deploy WordPress
- Configure NGINX Ingress Controller

## Components Explained

- **HAProxy**: Acts as the entry point, distributing traffic across WordPress pods.
- **WordPress Deployment**: Scalable WordPress instances.
- **MySQL StatefulSet**: Provides a primary-replica setup for data persistence and high availability.
- **NFS Server**: Offers shared storage for WordPress media files.
- **NGINX Ingress**: Manages external access to services, including SSL/TLS termination.

## Security Considerations
While this project demonstrates core concepts, it's important to note that additional security measures should be implemented for production use, including:

- Proper network segmentation (use of private subnets)
- Implementing a bastion host for secure SSH access
- Enhancing EC2 instance security
- Implementing proper secrets management
- Regular security audits and updates

## Enhancements

- **Private Subnet for MySQL**: Move the MySQL database into a private subnet for improved security, preventing direct internet access.
- **Monitoring System**: Implement monitoring tools like Prometheus and Grafana to track infrastructure and application performance.
- **Logging**: Centralize application and infrastructure logs using ELK stack (Elasticsearch, Logstash, Kibana).
- **Backup Strategy**: Set up automated backups for MySQL and WordPress data, stored in an S3 bucket for disaster recovery.
- **Scalability**: Expand the cluster to support more WordPress instances and database replicas as traffic grows.

## References

[Install a Kubernetes cluster with K3s](https://viblo.asia/p/k3s-la-gi-cai-dat-mot-cum-kubernetes-cluster-voi-k3s-gAm5yD7Xldb)  
[Install the NFS server and NFS dynamic provisioning on Azure virtual machines](https://medium.com/@shatoddruh/kubernetes-how-to-install-the-nfs-server-and-nfs-dynamic-provisioning-on-azure-virtual-machines-e85f918c7f4b)  
[Run a Replicated Stateful Application](https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/)  
[Deploying WordPress and MySQL with Persistent Volumes](https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)  
[Self Signed certificate and Use them in Haproxy and Allow certificate in MacOS](https://sharmank.medium.com/self-signed-certificate-and-use-them-in-haproxy-and-allow-certificate-in-macos-26c3aad316bb)  
