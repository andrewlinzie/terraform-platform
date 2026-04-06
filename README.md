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

On merge to `main`, **dev may auto-apply**, but only when relevant.

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

## Variable & Secrets Management

Terraform variables are intentionally split by **sensitivity and execution context**.

### Variable Types

#### 1. `terraform.tfvars` (Local Only)
- Used for local development and testing
- Contains sensitive or user-specific values
- **Not committed to Git**

Examples:
- `trusted_cidr_blocks`
- `cms_public_key`

---

#### 2. `terraform.tfvars.example` (Template)
- Committed to Git
- Provides a reference structure for required variables
- Does not contain real values

---

#### 3. `ci.tfvars` (CI Runtime Configuration)
- Committed to Git
- Contains **non-sensitive, environment-specific values**
- Used by GitHub Actions during plan/apply/destroy

Examples:
- region
- VPC CIDR ranges
- subnet configuration
- cluster naming
- scaling parameters

Each environment has its own:
- `environments/dev/ci.tfvars`
- `environments/staging/ci.tfvars`
- `environments/prod/ci.tfvars`

---

#### 4. `TF_VAR_*` GitHub Secrets (Sensitive CI Inputs)
- Stored in GitHub repository secrets
- Injected at runtime into Terraform

Examples:
- `TF_VAR_trusted_cidr_blocks`
- `TF_VAR_cms_public_key`

---

### Key Principles

- **No secrets are committed to Git**
- **CI is fully non-interactive**
- **Local and CI configurations are clearly separated**
- **All environments use consistent variable structure**

This design ensures:
- secure handling of sensitive data
- reproducible infrastructure across environments
- compatibility with automated CI/CD pipelines

---

## Container Registry Strategy (ECR)

Amazon ECR is treated as **shared infrastructure**, not environment-specific infrastructure.

### Design Decision

ECR repositories are created **once per AWS account/region**, not per environment.

Repositories:
- `api-service`
- `ai-inference-service`
- `cms-monolith`

---

### Why Shared ECR

This aligns with the principle of **immutable artifacts**:

- build once → push image → reuse across environments
- environments differ by:
  - configuration
  - deployment targets
  - scaling behavior

Not by rebuilding or duplicating container images.

---

### Environment Behavior

- **dev**
  - may create or reference ECR repositories
- **staging**
  - does NOT create ECR repositories
- **prod**
  - does NOT create ECR repositories

In staging and prod:

repository_names = []

This prevents:

* resource conflicts
* duplicate registry objects
* unnecessary infrastructure duplication

---

## State Management

Terraform uses a **remote backend** for all environments.

### Backend Configuration

* **S3 bucket**

  * stores Terraform state
  * versioning enabled
  * encryption enabled

* **DynamoDB table**

  * used for state locking
  * prevents concurrent modifications

Each environment has:

* its own backend config file:

  * `backend/dev.hcl`
  * `backend/staging.hcl`
  * `backend/prod.hcl`
* isolated state

---

### Key Principles

* **No local state for shared infrastructure**
* **State is environment-isolated**
* **State locking prevents race conditions**

---

## Repository Structure

terraform-platform/
├── modules/                # Reusable Terraform modules
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── backend/                # Remote state configuration
└── bootstrap/              # Backend provisioning (S3 + DynamoDB)

---

## How to Use

### 1. Initialize Terraform

```bash
terraform init -backend-config=...
```

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

## Operational Notes

### Execution Model

Terraform should be executed through:

* **GitHub Actions (primary path)**

Local execution is intended only for:

* development
* debugging

---

### Stale Locks

If a CI job is canceled during execution:

* a DynamoDB lock may remain

To resolve:

* verify no active job is running
* manually remove the stale lock from DynamoDB

---

### What Not to Commit

Do NOT commit:

* `.terraform/`
* `terraform.tfvars`
* `.terraform.lock.hcl` (unless intentionally tracked)
* any sensitive values or credentials

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

* GitOps (Argo CD) integration for application deployment
* CI pipeline enhancements (caching, parallelization)
* Observability stack (Prometheus, Grafana)
* IAM and security hardening
* Advanced deployment strategies (blue/green, canary)

---

## Summary

This repository implements a **production-style Terraform platform** with:

* environment-isolated infrastructure
* CI-driven infrastructure delivery
* OIDC-based authentication (no static AWS keys)
* controlled promotion across environments
* shared container registry strategy
* secure variable and secrets handling

The design prioritizes:

* **safety**
* **repeatability**
* **environment consistency**
* **clear separation of concerns**