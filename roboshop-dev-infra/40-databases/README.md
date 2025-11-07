# Terraform Databases Module

This folder contains Terraform code to provision and configure database-related infrastructure for the **Roboshop** project in a specified environment. It deploys **MongoDB, Redis, RabbitMQ, and MySQL** instances on AWS, along with DNS records in Route53. The setup uses a combination of Terraform, EC2 instances, and Ansible for configuration.

---

---

## Prerequisites

- AWS account with proper permissions for EC2, SSM, IAM, and Route53.
- Terraform installed (v1.x recommended)
- Ansible installed on local machine (optional if using `bootstrap.sh`)
- IAM role `EC2SSMParameterRead` created for EC2 instances to read SSM parameters.
- Existing security groups for databases (`mongodb`, `redis`, `mysql`, `rabbitmq`) in the target environment.
- Route53 hosted zone for the domain (e.g., `daws86s.fun`).

---

## Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `project_name` | `roboshop` | Name of the project. Used in tags and naming resources. |
| `environment` | `dev` | Deployment environment (`dev`, `prod`, etc.) |
| `sg_names` | List of SGs | List of security groups to reference |
| `zone_id` | `Z0948150OFPSYTNVYZOY` | Route53 hosted zone ID |
| `domain_name` | `daws86s.fun` | Domain name for DNS records |

---

## How It Works

1. **Bootstrap Script**  
   `bootstrap.sh` is copied to each EC2 instance and executed using Terraform `remote-exec` provisioners. It installs Ansible and runs relevant playbooks for each component.

2. **EC2 Instances**  
   - **MongoDB, Redis, RabbitMQ, MySQL** are provisioned using `aws_instance`.
   - Each instance uses:
     - Custom AMI from `data.aws_ami.joindevops`.
     - Security group from SSM parameters.
     - Database subnet from SSM parameter `database_subnet_ids`.
     - Tags including project, environment, and Terraform flag.

3. **Provisioning**  
   Terraform uses `file` and `remote-exec` provisioners to copy `bootstrap.sh` and configure each service.  
   Example:
   ```bash
   sudo sh /tmp/bootstrap.sh mongodb

4. **Route53 DNS Records** 
   DNS records are created for each database instance:
    mongodb-<env>.<domain>
    redis-<env>.<domain>
    mysql-<env>.<domain>
    rabbitmq-<env>.<domain>

##  Usage. 
  ```bash
Initialize Terraform:

terraform init


Preview the changes:

terraform plan


Apply the configuration:

terraform apply

  

