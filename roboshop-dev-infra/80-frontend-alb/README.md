# 🚀 Frontend Application Load Balancer (ALB) Setup

This Terraform module provisions a **public-facing Application Load Balancer (ALB)** for the Roboshop frontend application. It handles secure HTTPS traffic and maps a custom domain using Route53.

---

## 📁 Resources Created

### 1️⃣ `aws_lb.frontend_alb`
Creates a **public Application Load Balancer** in public subnets.

- **internal:** `false` → Makes it internet-facing  
- **load_balancer_type:** `application`  
- **security_groups:** References the ALB security group  
- **subnets:** Uses public subnet IDs  
- **tags:** Includes project and environment tags  

---

### 2️⃣ `aws_lb_listener.frontend_alb`
Configures an **HTTPS listener** on port **443** with an **ACM SSL certificate**.

- **protocol:** `HTTPS`  
- **ssl_policy:** `ELBSecurityPolicy-TLS13-1-3-2021-06` (for modern TLS 1.3 security)  
- **certificate_arn:** Retrieved from `local.frontend_alb_certificate_arn`  
- **default_action:** Returns a static HTML response for testing:  
  ```html
  <h1>Hi, I am from HTTPS frontend ALB</h1>


###  3️⃣ aws_route53_record.frontend_alb

Creates a **DNS A record (alias)** in Route53 that maps the custom domain to the ALB.

- **zone_id**: Provided via variable var.zone_id
- **name**: roboshop-${var.environment}.${var.domain_name} → Example:roboshop-dev.jansi1.site
- **alias** : Points to the ALB’s DNS name and zone ID
- **evaluate_target_health**: true for ALB health checks

### ⚙️ After Running **terraform apply**

Once applied successfully:
✅ A public HTTPS ALB is created.

### 🌐 Access your site at:
 ```bash
https://roboshop-dev.jansi1.site
  ```

### 🧾 You should see the message:
 ```bash
Hi, I am from HTTPS frontend ALB
  ```

### 🔧 The ALB is ready to attach:

- **Listener Rules**
- **Target Groups (for React frontend / Nginx services)**



### 🪄 Example Use
 ```bash
terraform init
terraform plan
terraform apply -auto-approve
  ```

### Then open your browser and visit:
 ```bash
👉 https://roboshop-dev.jansi1.site 
 ```