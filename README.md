# WordPress Application Cluster on K3s

This project demonstrates deploying a highly available WordPress application cluster using K3s, a lightweight Kubernetes distribution, on AWS infrastructure. It implements a three-tier architecture with separate management, application, and data layers for optimal performance and security.

## Table of Contents

- [WordPress Application Cluster on K3s](#wordpress-application-cluster-on-k3s)
  - [Table of Contents](#table-of-contents)
  - [Project Overview](#project-overview)
  - [Project Structure](#project-structure)
  - [Architecture](#architecture)
  - [Prerequisites](#prerequisites)
  - [Deployment Steps](#deployment-steps)
  - [Debugging](#debugging)
  - [References](#references)

## Project Overview

This project aims to create a scalable WordPress deployment using modern DevOps practices and tools. It leverages:

- Terraform for infrastructure as code (IaC)
- Ansible for configuration management and application deployment
- K3s for a lightweight Kubernetes environment
- HAProxy for load balancing and SSL termination
- MySQL with master-slave replication for data persistence
- NFS for shared storage
- OpenVPN for secure remote access
- Jenkins for continuous integration and deployment (CI/CD)

## Project Structure
```
.
├── ansible
│   ├── group_vars
│   │   ├── all.yml
│   │   └── vault.yml
│   ├── inventory
│   │   └── hosts.yml
│   ├── roles
│   ├── ansible.cfg
│   └── site.yml
├── aws-terraform-infrastructure
│   ├── keys
│   ├── modules
│   ├── terraform.lock.hcl
│   ├── main.tf
│   ├── outputs.tf
│   └── variable.tf
├── images
├── .gitignore
└── README.md
```

## Architecture

<img src="./images/Diagram.svg" alt="Description"/>

## Prerequisites

Before you begin, ensure you have the following installed:

- AWS CLI configured with appropriate credentials
- Terraform (version 0.14+)
- Ansible (version 2.9+)

## Deployment Steps

### 1. Set Up AWS Infrastructure
Copy the `terraform.tfvars.example` file to `terraform.tfvars` and update the values with your AWS credentials and desired configuration.

Then, run the following commands to create the infrastructure:
```bash
cd aws-terraform-infrastructure/
terraform init
terraform plan
terraform apply
```
Take note of the output values, as they'll be needed for Ansible configuration. Example:
 ```bash
  "management_eip" = [
    "54.224.69.231",
  ]
```

### 2. Configure Ansible Inventory
Update the `./ansible/group_vars/all.yml` file with the information from Terraform output:
```yaml
---
instances:
  - name: "management-server-instance-0"
    private_ip: "10.0.1.10"
    public_ips: "54.224.69.231" # Replace by `public_ips`
    dns_name: "ec2-54-224-69-231.compute-1.amazonaws.com" # Replace by `dns_names`
...
```
### 3. Set up Secrets for Database
In terminal, create encrypted passwords file:
```bash
ansible-vault create group_vars/vault.yml
```
Add the following content:
```yml
vault_mysql_root_password: "123456@Za"
vault_mysql_password: "123456@Za"
vault_mysql_slave_password: "123456@Za"
```
*Note: Replace these passwords with strong, secure passwords in production.*

To edit content in vault, using command:
```bash
ansible-vault edit group_vars/vault.yml
```

### 4. Install Required Ansible Collections
```bash
ansible-galaxy collection install community.general
ansible-galaxy collection install kubernetes.core
```

### 5. Deploy K3s Cluster and Applications
```bash
cd ../ansible/
ansible-playbook site.yml --ask-vault-pass
```
This playbook will:
- Install K3s on master and worker nodes
- Deploy HAProxy load balancer
- Set up MySQL replication
- Deploy WordPress
- Configure NGINX Ingress Controller

### 6. Access the WordPress Application
Access the WordPress application by visiting the public IP address or DNS of the Management Server in a web browser.

*Example*: `https://ec2-54-224-69-231.compute-1.amazonaws.com`

### 7. Access Jenkins and OpenVPN (Optional)
- Jenkins: `http://<management-server-public-ip>:8080`
- OpenVPN: Download the OpenVPN configuration file from the home of Management Server and connect using a VPN client.

## Debugging
When you encounter an error and need to rerun the playbook:
1. Using ```--start-at-task```: Rerun from the failed task. Example:
   ```bash
   ansible-playbook site.yml --start-at-task="Generate client configuration files" --ask-vault-pass
   ```
2. Use --limit to run only on the failed host. Example:
   ```bash
   ansible-playbook site.yml --limit dev-master-1 --ask-vault-pass
   ```
SSH manual to the hosts in private subnet:

*Example*:
```bash
# SSH to master node
ssh-keygen -R 10.0.10.10 # Remove the old key (optional)
ssh -o ProxyCommand="ssh -W %h:%p -i ttdn-key.pem ubuntu@<ip_public>" -i ttdn-key.pem ubuntu@10.0.10.10
```

## References

[Install a Kubernetes cluster with K3s](https://viblo.asia/p/k3s-la-gi-cai-dat-mot-cum-kubernetes-cluster-voi-k3s-gAm5yD7Xldb)  
[Install the NFS server and NFS dynamic provisioning on Azure virtual machines](https://medium.com/@shatoddruh/kubernetes-how-to-install-the-nfs-server-and-nfs-dynamic-provisioning-on-azure-virtual-machines-e85f918c7f4b)  
[Run a Replicated Stateful Application](https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/)  
[Deploying WordPress and MySQL with Persistent Volumes](https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)  
[Self Signed certificate and Use them in Haproxy and Allow certificate in MacOS](https://sharmank.medium.com/self-signed-certificate-and-use-them-in-haproxy-and-allow-certificate-in-macos-26c3aad316bb)  