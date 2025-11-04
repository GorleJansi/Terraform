# Security Group Module – roboshop-dev

This Terraform configuration automates the creation of multiple AWS Security Groups (SGs) and stores their IDs in AWS Systems Manager (SSM) Parameter Store. It also retrieves the required VPC ID from SSM instead of hardcoding it, ensuring modularity and reusability across environments.

---

## Overview

The setup dynamically:
1. Fetches the existing VPC ID from SSM.
2. Creates multiple Security Groups (one per component, such as catalogue, cart, user, etc.).
3. Exposes all SG IDs as Terraform outputs.
4. Stores each SG ID in SSM Parameter Store under a structured path for future use by other modules.

---

## File-by-File Explanation

### 1. main.tf
This is the core file where the SG module is invoked.  
- It uses the `count` meta-argument to create one SG per entry in the `sg_names` list.  
- The SGs are created using a remote module stored in your GitHub repository (`terraform-aws-sg`).  
- Each SG receives a unique name, description, and is associated with the retrieved VPC ID.  
- The code is modular and environment-aware, ensuring the same setup can be used for dev, staging, or prod.

**Outcome:**  
Multiple Security Groups are created in the specified VPC — one for each component (e.g., mongodb, catalogue, frontend, etc.).

---

### 2. data.tf
This file fetches the VPC ID from AWS SSM Parameter Store.  
- It looks up a parameter path like `/roboshop/dev/vpc_id`, which should already exist.  
- This ensures you don’t need to hardcode or manually input VPC IDs in the configuration.

**Outcome:**  
The correct VPC ID is dynamically retrieved from SSM and made available for all dependent resources.

---

### 3. locals.tf
This file defines local variables used for internal referencing.  
- `common_name_suffix` combines project name and environment (e.g., `roboshop-dev`) for consistent naming.  
- `vpc_id` stores the fetched VPC ID from the SSM data source, making it easy to reuse within the module.

**Outcome:**  
Simplifies variable references and enforces consistent naming patterns across resources.

---

### 4. outputs.tf
This file exposes the list of created Security Group IDs.  
- It outputs all SG IDs created by the module, so they can be easily referenced elsewhere or verified after deployment.

**Outcome:**  
You can view all SG IDs with `terraform output sg_id`, or consume them from another Terraform module.

---

### 5. parameters.tf
This file stores each created SG ID into AWS SSM Parameter Store.  
- Each SG ID is saved using a structured naming convention like `/roboshop/dev/catalogue_sg_id`.  
- This makes it easy for other infrastructure modules (like EC2, ALB, or RDS) to fetch the correct SGs when needed.

**Outcome:**  
All SG IDs are securely stored in Parameter Store, organized by project and environment.

---

### 6. provider.tf
This file configures Terraform backend and AWS provider settings.  
- The S3 backend is used to store Terraform state remotely and securely.  
- State locking and encryption are enabled to prevent conflicts and ensure data safety.  
- AWS provider is configured for the `us-east-1` region.

**Outcome:**  
Terraform state is centralized, versioned, and safely stored in S3, ensuring consistent deployments.

---

### 7. variables.tf
This file defines input variables used across the configuration.  
- `project_name` and `environment` define the naming and hierarchy for all resources.  
- `sg_names` is a predefined list of all application components for which Security Groups will be created (e.g., databases, backends, frontends, load balancers, bastion host).

**Outcome:**  
The configuration automatically generates SGs for every component listed here, ensuring scalability and consistency.

---

## Final Output Summary

After running:
- terraform init
- terraform apply


You will have:
- Multiple Security Groups created in your AWS VPC.
- Each SG tagged and named following your project and environment conventions.
- All SG IDs stored under SSM Parameter Store for easy cross-module access.
- A Terraform output displaying all SG IDs.

---

## Example Results

| Component | Example SSM Parameter | Example Value |
|------------|-----------------------|----------------|
| catalogue  | /roboshop/dev/catalogue_sg_id | sg-0123abcd... |
| cart       | /roboshop/dev/cart_sg_id | sg-0456efgh... |
| frontend   | /roboshop/dev/frontend_sg_id | sg-0789ijkl... |

---

## Key Benefits
✅ Centralized management of Security Groups.  
✅ Reusable and environment-agnostic design.  
✅ Parameter Store integration for seamless dependency sharing.  
✅ Modular and version-controlled setup using GitHub modules.  
✅ Remote state backend for collaboration and safety.

---
