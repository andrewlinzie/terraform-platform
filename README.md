# terraform-platform

## Purpose
Defines and provisions AWS infrastructure for the ai-cloud-platform using Terraform.

This includes networking, compute, security, and container registry components required to support a hybrid architecture:
- Microservices (API + AI) on EKS
- Internal CMS on EC2

---

## Architecture Overview

The platform provisions:

### Networking
- VPC with public and private subnets
- Internet Gateway + NAT Gateway
- Route tables for traffic control

### Compute
- **EKS Cluster**
  - Runs API and AI inference services
  - Managed node groups with autoscaling
- **EC2 Instance (CMS)**
  - Docker-based deployment via user_data
  - SSH access restricted via CIDR

### Security
- Security groups for:
  - EKS control plane
  - EKS worker nodes
  - CMS EC2 instance
- IAM roles and instance profiles (least privilege)

### Container Registry
- Amazon ECR repositories:
  - api-service
  - ai-inference-service
  - cms-monolith

---

## Environment Model

Supports three isolated environments:

- `dev`
- `staging`
- `prod`

Each environment:
- Uses separate Terraform state (S3 + DynamoDB)
- Has isolated VPC CIDR ranges
- Uses environment-specific naming and scaling
- Shares the same infrastructure architecture

---

## Terraform CI/CD Workflow

Infrastructure is provisioned and managed through **GitHub Actions**, not manual local execution.

### Execution Model

#### Pull Requests
On any Terraform-related change:

- `terraform fmt -check`
- `terraform validate`
- `terraform plan`

Plans are executed for all environments:
- `dev`
- `staging`
- `prod`

This ensures that changes to shared modules or configuration are validated across all environments before merge.

---

#### Push to `main`

On merge to `main`, **dev may auto-apply**, but only when relevant:

Auto-apply is triggered if changes affect:
- `modules/**`
- `backend/**`
- `.github/workflows/**`
- `environments/dev/**`

Auto-apply is **NOT triggered** if changes only affect:
- `environments/staging/**`
- `environments/prod/**`

This prevents unnecessary or misleading deployments in dev.

---

#### Manual Execution (workflow_dispatch)

Controlled execution is required for higher environments:

- **staging**
  - apply → manual
  - destroy → manual

- **prod**
  - apply → manual
  - destroy → manual

This enforces safe promotion and avoids accidental production changes.

---

#### Destroy Behavior

Destroy operations are:
- always manually triggered
- environment-specific
- executed through the same CI workflow

---

## Repository Structure

```

terraform-platform/
├── modules/                # Reusable Terraform modules
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── backend/                # Remote state configuration
└── bootstrap/              # Backend provisioning (S3 + DynamoDB)

````

---

## How to Use

### 1. Initialize Terraform
```bash
terraform init -backend-config=...
````

### 2. Configure Variables

Copy the example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update:

* `trusted_cidr_blocks`
* `cms_public_key`

### 3. Plan and Apply

```bash
terraform plan
terraform apply
```

---

## Key Design Decisions

* **Environment Parity**

  * Same Terraform structure across dev, staging, and prod
  * Differences handled via input variables only

* **Separation of Concerns**

  * Modules for reusable infrastructure
  * Environments for composition

* **Security First**

  * Restricted CIDR access for SSH
  * No secrets committed to Git

* **Immutable Infrastructure Approach**

  * Infra defined entirely in code
  * No manual AWS configuration

---

## Does Not Contain

* Application source code
* GitOps deployment state (Argo CD)
* Dockerfiles
* Jenkins pipeline logic

---

## Future Enhancements

* Terraform CI/CD pipeline (GitHub Actions)
* OIDC authentication (no static AWS credentials)
* Environment-based approval workflows
* Argo CD integration for GitOps deployment