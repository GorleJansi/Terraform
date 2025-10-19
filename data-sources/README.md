## ✅ Key Takeaways

- Terraform builds a **Directed Acyclic Graph (DAG)** of all configurations.
- **Data sources** are always resolved before **resources** or **outputs**.
- **Filters** in data sources let Terraform fetch only specific, valid results.
- **Outputs** show or export important information after provisioning.
- **State file** maintains all dependency links for future operations.


```bash

## 🧩 Internal DAG Example

Terraform internally maps dependencies like this:

data.aws_ami.joindevops ───▶ output.ami_id
data.aws_instance.mongodb ─▶ output.mongodb_info

Each arrow (▶) represents a dependency.
Terraform ensures all dependencies are evaluated in order before producing outputs.


data.aws_ami.joindevops(data-source)
          │
          ▼
aws_instance.web(resouce)
          │
          ▼
output.web_ip(output)
```

```bash

## ⚙️ How Terraform Builds and Executes the Dependency Graph (DAG)

| Step | Action | Explanation |
|------|---------|-------------|
| 1️⃣ | Read `.tf` files | Terraform scans all configuration files (provider, data, outputs, etc.) in the working directory. |
| 2️⃣ | Identify references | Detects relationships like `data.aws_ami.joindevops.id` and `data.aws_instance.mongodb.public_ip`. |
| 3️⃣ | Build the DAG | Constructs an internal graph where each node represents a resource or data source. Example: `data.aws_ami.joindevops → aws_instance.web`. |
| 4️⃣ | Determine order | Ensures Terraform executes blocks in the correct dependency sequence (data → resources → outputs). |
| 5️⃣ | Run `terraform plan` | Compares the **current state** (`terraform.tfstate`) with the **desired configuration** (`.tf` files). |
| 6️⃣ | Fetch Data Sources | Executes all `data` blocks first (e.g., gets latest AMI using filters or reads EC2 info). |
| 7️⃣ | Replace references | Dynamically injects fetched data: `data.aws_ami.joindevops.id` → actual AMI ID. |
| 8️⃣ | Create / Update resources | Creates or modifies resources **after** all dependencies are resolved. |
| 9️⃣ | Generate Outputs | Evaluates `output` blocks and displays results in the CLI (e.g., instance ID, public IP). |
| 🔟 | Save state | Stores all resolved dependencies and values in `terraform.tfstate` for future runs. |

---

## 🌊 Why Use `output` Blocks?

| Purpose | Description | Example |
|----------|-------------|----------|
| Visibility | Display key info after `terraform apply`. | `output "ami_id" { value = data.aws_ami.joindevops.id }` |
| Reusability | Pass values between Terraform modules. | Module A → Module B |
| Debugging | Quickly verify resource attributes. | `output "instance_info" { value = aws_instance.web.public_ip }` |

---

## 🔁 Terraform Dependency Graph (DAG) Flow

```bash
+------------------------+
|     provider.tf        |
| (defines AWS provider) |
+-----------+------------+
            |
            v
+------------------------+
|     data sources       |
| e.g. aws_ami, aws_vpc  |
| (fetched first)        |
+-----------+------------+
            |
            v
+------------------------+
|     resources.tf       |
| e.g. aws_instance, SG  |
| (depends on data)      |
+-----------+------------+
            |
            v
+------------------------+
|     outputs.tf         |
| e.g. public_ip, ami_id |
| (depends on resources) |
+-----------+------------+
            |
            v
+------------------------+
|   terraform.tfstate    |
| (stores current state) |
+------------------------+
```

```bash
## 🧰  Hands-on Validation Commands

# View dependency graph visually
terraform graph | dot -Tpng > graph.png

# Validate configuration syntax
terraform validate

# Show planned execution order
terraform plan

# Apply and view outputs
terraform apply
terraform output

```


