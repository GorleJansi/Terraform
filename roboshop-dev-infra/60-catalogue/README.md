# 🧩 Roboshop Catalogue Service - Terraform Setup

This Terraform module automates the complete setup for the **Catalogue** microservice in the Roboshop application.  
It provisions infrastructure, configures the app using Ansible, creates a reusable AMI, and deploys an Auto Scaling setup behind an Application Load Balancer (ALB).

---

## 📘 Overview

The setup performs the following key actions in sequence:

1. **Launches a temporary EC2 instance**
   - Uses a base AMI from AWS (`RHEL-9-DevOps-Practice`)
   - Deploys in a private subnet with the correct security group

2. **Configures the Catalogue component**
   - Copies and runs the `catalogue.sh` script
   - Installs Ansible and pulls roles from the GitHub repo
   - Executes the Ansible playbook to configure the application

3. **Creates a custom AMI**
   - Stops the configured EC2 instance
   - Captures it as a reusable AMI for future deployments

4. **Sets up Launch Template and Auto Scaling Group (ASG)**
   - Uses the newly created AMI
   - Defines instance type, security groups, and tags
   - Auto Scaling Group launches instances in private subnets
   - Integrates with an ALB Target Group for load balancing

5. **Enables Auto Scaling**
   - Adds a scaling policy to adjust capacity based on average CPU utilization (target 75%)

6. **Configures ALB Listener Rule**
   - Routes traffic from the backend ALB to the Catalogue Target Group
   - Uses host-based routing (e.g., `catalogue.backend-alb-dev.daws86s.fun`)

7. **Cleans up temporary resources**
   - Terminates the temporary EC2 instance used for AMI creation

---

## 🧠 File Breakdown

| File | Description |
|------|--------------|
| **provider.tf** | Configures AWS provider and S3 backend for remote Terraform state |
| **variables.tf** | Defines project-level variables (project name, environment, domain) |
| **data.tf** | Fetches required infrastructure data (AMI, VPC, subnets, SGs, ALB listener ARN) from AWS SSM |
| **locals.tf** | Defines reusable local variables like name suffix, common tags, and IDs |
| **main.tf** | Main Terraform file that creates resources — EC2, AMI, Launch Template, ASG, ALB TG, scaling policies, and cleanup tasks |
| **catalogue.sh** | Bash script executed on EC2 to install Ansible, clone playbook repo, and run configuration for the Catalogue component |

---

## 🏗️ Resource Creation Flow

1. **EC2 Instance**
   - Created temporarily to install and configure the Catalogue application.

2. **Ansible Configuration**
   - `catalogue.sh` installs Ansible and runs:
     ```bash
     ansible-playbook -e component=catalogue -e env=dev main.yaml
     ```

3. **AMI Creation**
   - The configured EC2 instance is stopped and converted into a reusable AMI.

4. **Launch Template**
   - Uses the AMI to define how new instances should launch.

5. **Auto Scaling Group**
   - Launches and maintains Catalogue instances across private subnets.
   - Integrates with the ALB Target Group for traffic routing.

6. **Scaling Policy**
   - Automatically scales instances based on CPU load.

7. **Listener Rule**
   - Directs traffic to the correct Target Group when requests hit:
     ```
     catalogue.backend-alb-dev.daws86s.fun
     ```

8. **Cleanup**
   - Deletes the temporary EC2 instance used for the AMI build.

---

## ⚙️ Prerequisites

Before applying this Terraform code:
- Ensure you have a **VPC, private subnets, and ALB** already created.
- The following values must exist in **AWS SSM Parameter Store**:
   /roboshop/dev/private_subnet_ids
   /roboshop/dev/catalogue_sg_id
   /roboshop/dev/vpc_id
   /roboshop/dev/backend_alb_listener_arn
- AWS credentials must be configured in your environment.

---

## 🚀 How to Deploy

1. Initialize Terraform:
 ```bash
 terraform init

2. Review the plan:
 ```bash
  terraform plan 

3. Apply the configuration:
 ```bash
 terraform apply -auto-approve

---

## 🧹 Cleanup

To destroy the infrastructure:
 ```bash
terraform destroy -auto-approve

---

## 🏁 Outcome

After successful deployment:
The Catalogue service is fully configured and running in AWS.
The service is load-balanced by the backend ALB.
The setup is scalable and self-healing via Auto Scaling.
Future Catalogue instances are created from a golden AMI for faster bootstrapping.