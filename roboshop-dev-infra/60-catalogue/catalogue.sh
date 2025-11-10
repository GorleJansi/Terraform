#!/bin/bash
# The shebang line specifies that this script should be run with the Bash shell.

component=$1
environment=$2
# Takes two positional arguments when running the script:
# $1 → component name (e.g., "catalogue", "user", "cart", etc.)
# $2 → environment name (e.g., "dev", "prod", "staging", etc.)

dnf install ansible -y
# Installs Ansible using the DNF package manager (used in RHEL/CentOS/Amazon Linux 2023).
# The '-y' flag auto-confirms installation prompts.

REPO_URL=https://github.com/daws-86s/ansible-roboshop-roles-tf.git
# The Git repository URL where Ansible playbooks and roles are stored.

REPO_DIR=/opt/roboshop/ansible
# The base directory where the Ansible repository will be cloned or updated.

ANSIBLE_DIR=ansible-roboshop-roles-tf
# The folder name of the cloned repository.

mkdir -p $REPO_DIR
# Creates the repository directory if it doesn’t already exist.
# '-p' ensures parent directories are also created if missing.

mkdir -p /var/log/roboshop/
# Creates a directory for storing Roboshop logs.

touch ansible.log
# Creates an empty log file named 'ansible.log' in the current directory (if not existing).
# Can be used later for redirecting logs.

cd $REPO_DIR
# Navigates into the repository directory.

# Check if the Ansible repository is already cloned
if [ -d $ANSIBLE_DIR ]; then
    # If the folder exists, it means the repo is already cloned
    cd $ANSIBLE_DIR
    git pull
    # Pulls the latest updates from the GitHub repository.
else
    # If the repo isn’t cloned yet, clone it fresh.
    git clone $REPO_URL
    cd $ANSIBLE_DIR
fi

echo "environment is: $2"
# Prints the environment value for logging/debugging.

ansible-playbook -e component=$component -e env=$environment main.yaml
# Runs the Ansible playbook 'main.yaml'
# Passes two extra variables:
#   component → which microservice or app component to configure
#   env → which environment to use (dev/test/prod)
# Example:
#   ansible-playbook -e component=catalogue -e env=dev main.yaml
