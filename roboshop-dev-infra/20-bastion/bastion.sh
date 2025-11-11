# ============================================================
# Script: setup_databases.sh
# Purpose: Prepare EC2 instance for Terraform execution by:
#   1. Expanding /home volume
#   2. Installing Terraform
#   3. Cloning roboshop-dev-infra repo
#   4. Running Terraform to create database resources
# ============================================================


#!/bin/bash

# ------------------------------------------------------------
# 1. Grow the /home volume to increase available space
# ------------------------------------------------------------

# Extend the 4th partition on the main NVMe disk (/dev/nvme0n1p4)
# Used when EC2 uses LVM and /home is running out of space
growpart /dev/nvme0n1 4

# Extend the logical volume (homeVol) inside the RootVG volume group by 30 GB
lvextend -L +30G /dev/mapper/RootVG-homeVol

# Resize the XFS filesystem to use the newly allocated space
xfs_growfs /home


# ------------------------------------------------------------
# 2. Install Terraform
# ------------------------------------------------------------

# Install yum-utils (provides yum-config-manager and other tools)
sudo yum install -y yum-utils

# Add HashiCorp’s official YUM repo (contains Terraform packages)
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# Install Terraform from the added HashiCorp repo
sudo yum -y install terraform


# ------------------------------------------------------------
# 3. (Optional) Reduce root volume size (currently commented out)
# ------------------------------------------------------------
# This command would shrink the root logical volume to 6G.
# It's commented out because shrinking root volumes is risky.
# sudo lvreduce -r -L 6G /dev/mapper/RootVG-rootVol


# ------------------------------------------------------------
# 4. Clone roboshop-dev-infra repo and set permissions
# ------------------------------------------------------------

# Move to ec2-user’s home directory
cd /home/ec2-user

# Clone the infrastructure repository containing Terraform code
git clone https://github.com/daws-86s/roboshop-dev-infra.git

# Ensure the cloned repo and all its files are owned by ec2-user
# (-R = recursive, applies to all subfolders and files)
chown ec2-user:ec2-user -R roboshop-dev-infra


# ------------------------------------------------------------
# 5. Initialize and apply Terraform for database setup
# ------------------------------------------------------------

# Navigate to the "40-databases" Terraform folder inside the repo
cd roboshop-dev-infra/40-databases

# Initialize Terraform (downloads providers, sets up backend)
terraform init

# Apply Terraform configuration automatically without asking for confirmation
terraform apply -auto-approve


# ------------------------------------------------------------
# End of script
# ------------------------------------------------------------
