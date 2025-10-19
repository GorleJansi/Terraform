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
| 2️⃣ | Identify references | Detects relationships like `data.aws_ami.joindevops.id` and `data.aws_instance.mongodb.public_ip`. These become dependency links. |
| 3️⃣ | Build the DAG | Constructs an internal map where each node is a resource or data source. Example:<br>`data.aws_ami.joindevops → output.ami_id`<br>`data.aws_instance.mongodb → output.mongodb_info` |
| 4️⃣ | Determine order | Ensures Terraform executes blocks in the correct dependency sequence (data → resources → outputs). |
| 5️⃣ | Run `terraform plan` | Compares the **current state** (`terraform.tfstate`) with the **desired configuration** (from `.tf` files). |
| 6️⃣ | Fetch Data Sources | Executes all `data` blocks first:<br>☑️ Gets latest AMI using filters<br>☑️ Reads EC2 instance details |
| 7️⃣ | Replace references | Injects fetched data dynamically:<br>`data.aws_ami.joindevops.id` → actual AMI ID<br>`data.aws_instance.mongodb.public_ip` → instance IP |
| 8️⃣ | Create / update resources | If there are any resources, Terraform creates or updates them **after** all data dependencies are resolved. |
| 9️⃣ | Generate Outputs | Evaluates `output` blocks and displays their results in CLI.<br>Example:<br>`ami_id = ami-09c813fb71547fc4f`<br>`mongodb_info = 3.111.25.89` |
| 🔟 | Save state | Terraform stores all resolved dependencies and values in `terraform.tfstate` for future reference. |

```


```bash
## 📤 Why Use `output` Blocks?

| Purpose | Description | Example |
|----------|--------------|----------|
| Visibility | Display key information after `apply` | `ami_id`, `public_ip` |
| Reusability | Pass values between Terraform modules | Module A → Module B |
| Debugging | Quickly verify resource attributes | `output "instance_info" { value = aws_instance.web.public_ip }` |

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


