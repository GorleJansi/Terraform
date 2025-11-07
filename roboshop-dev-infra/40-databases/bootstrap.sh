#!/bin/bash

# -----------------------------------------------------------------------------
# Script: roboshop-ansible-deploy.sh
# Purpose: Automatically install Ansible, clone/update the Roboshop Ansible repo,
#          and run the Ansible playbook for the given component and environment.
# Usage:   ./roboshop-ansible-deploy.sh <component> <environment>
# Example: ./roboshop-ansible-deploy.sh frontend dev
# -----------------------------------------------------------------------------

# Take input arguments
component=$1      # Component name (e.g., frontend, catalogue, mongodb)
environment=$2    # Environment name (e.g., dev, qa, prod)

# -----------------------------------------------------------------------------
# Step 1: Install Ansible if not already installed
# -----------------------------------------------------------------------------
dnf install ansible -y    # Installs Ansible using dnf (works for RHEL/CentOS/Amazon Linux 2023)

# -----------------------------------------------------------------------------
# Step 2: Define variables for repo and directory paths
# -----------------------------------------------------------------------------
REPO_URL="https://github.com/daws-86s/ansible-roboshop-roles-tf.git"  # GitHub repo containing Ansible roles/playbooks
REPO_DIR="/opt/roboshop/ansible"                                      # Base directory for repo storage
ANSIBLE_DIR="ansible-roboshop-roles-tf"                               # Folder name created after cloning

# -----------------------------------------------------------------------------
# Step 3: Prepare directories and log file
# -----------------------------------------------------------------------------
mkdir -p $REPO_DIR                     # Ensure /opt/roboshop/ansible exists
mkdir -p /var/log/roboshop/            # Log directory for Roboshop deployments
touch /var/log/roboshop/ansible.log    # Create a log file if not already present

# -----------------------------------------------------------------------------
# Step 4: Go to the repo directory
# -----------------------------------------------------------------------------
cd $REPO_DIR

# -----------------------------------------------------------------------------
# Step 5: Clone or update the Ansible repository
# -----------------------------------------------------------------------------
if [ -d "$ANSIBLE_DIR" ]; then
    # If repo already exists, pull the latest changes
    echo "Ansible repo already exists. Pulling latest updates..."
    cd $ANSIBLE_DIR
    git pull
else
    # If not cloned yet, clone it fresh
    echo "Cloning Ansible repo..."
    git clone $REPO_URL
    cd $ANSIBLE_DIR
fi

# -----------------------------------------------------------------------------
# Step 6: Run the Ansible playbook with given variables
# -----------------------------------------------------------------------------
# -e option passes extra variables to Ansible (component & env)
# main.yaml is the entry point playbook
# -----------------------------------------------------------------------------
ansible-playbook -e component=$component -e env=$environment main.yaml | tee -a /var/log/roboshop/ansible.log

# -----------------------------------------------------------------------------
# Step 7: End message
# -----------------------------------------------------------------------------
echo "✅ Deployment completed for component: $component in environment: $environment"
echo "Logs saved to: /var/log/roboshop/ansible.log"
