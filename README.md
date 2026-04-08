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

**Runtime / tier environments** (each with its own VPC, EKS, CMS, and isolated state):

- `dev`
- `staging`
- `prod`

**Shared platform stack** (separate state; not a deployment tier):

- `shared` — shared resources used by every tier (for example, **ECR** repositories)

Each stack:

- Uses separate Terraform state (S3 + DynamoDB)
- Tier environments (`dev` / `staging` / `prod`) have isolated VPC CIDR ranges, naming, and scaling
- Shares the same module-based architecture

---

## Terraform CI/CD Workflow

Infrastructure is provisioned and managed through **GitHub Actions**, not manual local execution. The workflow file is **`.github/workflows/terraform-infra.yml`** (GitHub UI: **Terraform Infra**).

### Default automation: `dev` only (PR and push)

For **pull requests** and **pushes** to `main`, the workflow always uses **`environments/dev`** as the working directory (unless you use **workflow_dispatch**). It runs:

- `terraform fmt -check` (recursive from repo root)
- `terraform validate` in `environments/dev`
- `terraform plan` in `environments/dev` with `ci.tfvars`

So **PRs validate and plan the dev stack**. Edits to **shared modules** still show up in **dev’s** plan because dev composes those modules.

**Important:** A PR that changes **only** `environments/shared/**`, `environments/staging/**`, or `environments/prod/**` does **not** automatically plan that directory in the default pipeline—the job still targets **dev**. For those stacks, use **`workflow_dispatch`** (below) or run Terraform **locally** in the correct `environments/<name>` directory.

---

### Pull requests

On Terraform-related path changes, the workflow runs **fmt / validate / plan for dev** as described above.

---

### Push to `main`

On merge to `main`, **dev may auto-apply**, but only when relevant.

Auto-apply runs when path filters detect changes under:

- `modules/**`
- `backend/**`
- `.github/workflows/**`
- `environments/dev/**`

Auto-apply does **not** run when changes are limited to:

- `environments/staging/**`
- `environments/prod/**`
- `environments/shared/**`

That keeps merges to staging/prod/shared-only paths from silently applying **dev**.

---

### `shared` — explicit operator action only

The **`shared`** stack (e.g. ECR) is **not** part of the default PR plan target and is **not** auto-applied on push to `main`. Applying it is always an **explicit** choice:

1. **GitHub Actions:** open **Actions** → **Terraform Infra** → **Run workflow** → set **environment** to **`shared`** and **action** to **`apply`** (plan runs in the same workflow before apply).
2. **Local:** from `terraform-platform/environments/shared`, run `terraform init` with `backend/shared.hcl`, then `plan` / `apply` with the appropriate var files.

Apply **`shared`** before anything that depends on its resources (for example, pushing images to ECR).

---

### Manual execution (`workflow_dispatch`)

Use **workflow_dispatch** for stacks that must not follow the dev-only automation:

| Environment | Apply / destroy |
|-------------|-------------------|
| `shared`    | Manual only (operator triggers workflow or runs locally) |
| `staging`   | Manual |
| `prod`      | Manual |

`dev` can also be run manually via dispatch when you want an explicit apply outside the push-to-`main` path.

---

### Destroy behavior

Destroy operations are:

- always manually triggered
- environment-specific
- executed through **`terraform-infra.yml`** via **`workflow_dispatch`**, action **destroy**

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

Each stack has its own committed `ci.tfvars`:

- `environments/dev/ci.tfvars`
- `environments/staging/ci.tfvars`
- `environments/prod/ci.tfvars`
- `environments/shared/ci.tfvars`

---

#### 4. `TF_VAR_*` GitHub Secrets (Sensitive CI Inputs)
- Stored in GitHub repository secrets
- Injected at runtime into Terraform

Examples:
- `TF_VAR_trusted_cidr_blocks`
- `TF_VAR_cms_public_key`
- `TF_VAR_jenkins_public_key` — injected for all Terraform jobs; **only `environments/shared`** uses it (Jenkins EC2 key pair). Tier stacks declare an unused `jenkins_public_key` variable with default `""` so Terraform accepts the same env in one workflow. It is set to the same secret as `TF_VAR_cms_public_key` by default (one operator key); use a separate secret if Jenkins should use a different key.

---

### SSH keys and network access (tradeoffs)

This platform is aimed at a **personal / dev** workflow. The default CI wiring **reuses the same SSH public key** for the CMS instances (tier stacks) and the Jenkins controller (`shared`): one **private key** on your machine can open **both** hosts (under different EC2 key pair names in AWS). That keeps operations simple but **widens blast radius** if that private key is ever compromised.

**Mitigation used here:** **`trusted_cidr_blocks`** (and the Jenkins security group) restrict **SSH (22)** and **Jenkins UI (8080)** to addresses you list—typically **your home/public IP** (`x.x.x.x/32`). That is an important barrier: random internet hosts cannot attempt those ports even if they somehow learn a key name. Update the CIDR when your IP changes.

**If you harden later:** use **separate** key pairs (and secrets) for CMS vs Jenkins, rely more on **SSM Session Manager** (IAM-gated, no long-lived EC2 key pair), or both—especially if the project grows beyond solo dev.

---

### Key Principles

- **No secrets are committed to Git**
- **CI is fully non-interactive**
- **Local and CI configurations are clearly separated**
- **Tier environments (`dev` / `staging` / `prod`) use a consistent variable shape; `shared` adds platform-only inputs (ECR, Jenkins, its VPC)**

This design ensures:
- secure handling of sensitive data
- reproducible infrastructure across environments
- compatibility with automated CI/CD pipelines

---

## Container Registry Strategy (ECR)

Amazon ECR is treated as **shared infrastructure**, not environment-specific infrastructure.

### Design Decision

In Terraform, ECR repositories are created **only** in the **`shared`** stack (`environments/shared`, `module.ecr`). **`dev`**, **`staging`**, and **`prod`** do **not** instantiate the ECR module, expose ECR outputs, or carry `repository_names` variables.

Repository names (immutable tags / CI image URIs) are still the usual three:

- `api-service`
- `ai-inference-service`
- `cms-monolith`

### Downstream references (tier stacks)

Today, tier environments **do not** use `terraform_remote_state` to read the shared stack. Image pulls and CI use **account- and region-scoped ECR URLs** (for example in GitHub Actions variables and GitOps values). Add **`terraform_remote_state` → `shared`** only if a tier stack must consume Terraform outputs such as repository ARNs or URLs.

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

- **shared**
  - owns shared **ECR** repositories (immutable artifacts for all envs)
- **dev**, **staging**, **prod**
  - do **not** create ECR repositories; they consume images from the shared registry

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
  * `backend/shared.hcl`
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

```
terraform-platform/
├── modules/                # Reusable Terraform modules
├── environments/
│   ├── dev/
│   ├── shared/             # Shared platform (e.g. ECR)
│   ├── staging/
│   └── prod/
├── backend/                # Remote state configuration
└── bootstrap/              # Backend provisioning (S3 + DynamoDB)
```

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

* **GitHub Actions (primary path)** — **`.github/workflows/terraform-infra.yml`**; default PR/push jobs target **dev**; **`shared`** and higher tiers use **workflow_dispatch** or local runs (see **Terraform CI/CD Workflow** above).

Local execution is intended only for:

* development
* debugging
* **`shared`** (or other stacks) when you choose not to use Actions

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