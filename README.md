# eks-ecommerce-gitops

<div align="center">

![Banner](./docs/images/banner.png)

[![GitHub Stars](https://img.shields.io/github/stars/nithingowdahm87/eks-ecommerce-gitops?style=flat-square)](https://github.com/nithingowdahm87/eks-ecommerce-gitops/stargazers)
[![GitHub License](https://img.shields.io/github/license/nithingowdahm87/eks-ecommerce-gitops?color=green&style=flat-square)](./LICENSE)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.23%2B-326CE5?style=flat-square&logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=flat-square&logo=terraform&logoColor=white)](https://www.terraform.io)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-GitOps-EF7B4D?style=flat-square&logo=argo&logoColor=white)](https://argoproj.github.io/cd/)
[![AWS EKS](https://img.shields.io/badge/AWS-EKS-FF9900?style=flat-square&logo=amazonaws&logoColor=white)](https://aws.amazon.com/eks/)

**A production-grade microservices ecommerce platform deployed on AWS EKS using GitOps, Terraform, Docker, and ArgoCD.**

*Built and deployed independently by [NITHIN](https://github.com/nithingowdahm87)*

</div>

---

## Table of Contents

- [Overview](#overview)
- [Live Screenshots](#live-screenshots)
- [Architecture](#architecture)
- [Microservices](#microservices)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Terraform Deployment](#terraform-deployment)
- [GitOps with ArgoCD](#gitops-with-argocd)
- [CI/CD Pipeline](#cicd-pipeline)
- [Monitoring](#monitoring)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)

---

## Overview

This project demonstrates a fully containerized, cloud-native ecommerce application built from the ground up using modern DevOps practices. It features a multi-service architecture running on **Amazon EKS Auto Mode**, with GitOps-driven deployments managed by **ArgoCD**, infrastructure provisioned via **Terraform**, and a full CI/CD pipeline through **GitHub Actions**.

Key highlights:
- **5 independent microservices** — each containerized, versioned, and deployed separately
- **GitOps workflow** — all deployments are Git-driven; no manual `kubectl apply` in production
- **EKS Auto Mode** — AWS manages node lifecycle, scaling, and patching automatically
- **Dual-branch strategy** — `main` for demo/testing with public images, `gitops` branch for full production CI/CD
- **Helm charts** — each service has its own chart for clean, versioned releases
- **Full observability** — Prometheus + Grafana stack included

---

## Live Screenshots

### Storefront — Product Catalog
![Storefront](./docs/screenshots/app1.jpg)

### Product Listing (Second Page)
![Product Listing](./docs/screenshots/app2.jpg)

### Cart — Loadout View
![Cart](./docs/screenshots/app3.jpg)

### Checkout — Rendezvous Location
![Checkout](./docs/screenshots/app4.jpg)

### Application Services — Health Status
![Services Health](./docs/screenshots/app5.jpg)

### Kubernetes Metadata — Pod Info
![K8s Metadata](./docs/screenshots/app6.jpg)

### ArgoCD — Applications Dashboard
![ArgoCD Dashboard](./docs/screenshots/argoCD.jpg)

> All services running healthy in the `nithin-shop` namespace, managed by ArgoCD `v2.10.4`.

---

## Architecture

### Infrastructure Architecture

```
┌─────────────────────────────────────────────────────┐
│                     AWS Cloud                        │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │              Amazon EKS (Auto Mode)          │   │
│  │                                             │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  │   │
│  │  │    UI    │  │ Catalog  │  │   Cart   │  │   │
│  │  │  Service │  │ Service  │  │  Service │  │   │
│  │  └──────────┘  └──────────┘  └──────────┘  │   │
│  │                                             │   │
│  │  ┌──────────┐  ┌──────────┐                 │   │
│  │  │  Orders  │  │Checkout  │                 │   │
│  │  │  Service │  │ Service  │                 │   │
│  │  └──────────┘  └──────────┘                 │   │
│  │                                             │   │
│  │  Namespace: nithin-shop                     │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  ┌────────────┐  ┌──────────┐  ┌───────────────┐  │
│  │    VPC     │  │  ArgoCD  │  │  NGINX Ingress │  │
│  │ (pub+priv) │  │ (GitOps) │  │  + Cert Manager│  │
│  └────────────┘  └──────────┘  └───────────────┘  │
└─────────────────────────────────────────────────────┘
         ↑                    ↑
   Terraform IaC        GitHub Actions CI/CD
```

**Core infrastructure components:**
- **VPC** — Custom VPC with public and private subnets across multiple AZs
- **EKS Auto Mode** — Managed Kubernetes with automatic node provisioning and scaling
- **IAM** — Fine-grained roles and policies for cluster and workload access
- **ArgoCD** — GitOps operator that syncs Kubernetes state from this repository
- **NGINX Ingress** — External traffic routing and load balancing
- **Cert Manager** — Automated TLS certificate provisioning

---

## Microservices

| Service | Language | Docker Image | Description |
|---|---|---|---|
| [UI](./src/ui/) | Java | `nithin/nithin-shop-ui:v1.0` | Store frontend — product browsing, cart, checkout UI |
| [Catalog](./src/catalog/) | Go | `nithin/nithin-shop-catalog:v1.0` | Product catalog REST API |
| [Cart](./src/cart/) | Java | `nithin/nithin-shop-cart:v1.0` | Shopping cart management API |
| [Orders](./src/orders/) | Java | `nithin/nithin-shop-orders:v1.0` | Order creation and tracking API |
| [Checkout](./src/checkout/) | Node.js | `nithin/nithin-shop-checkout:v1.0` | Checkout orchestration API |

All services run in the `nithin-shop` Kubernetes namespace and communicate over internal cluster DNS.

---

## Prerequisites

Ensure the following tools are installed before you begin:

| Tool | Version | Install |
|---|---|---|
| AWS CLI | Latest | [Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) |
| Terraform | ≥ 1.0.0 | [Guide](https://developer.hashicorp.com/terraform/install) |
| kubectl | ≥ 1.23 | [Guide](https://kubernetes.io/docs/tasks/tools/) |
| Helm | ≥ 3.0 | [Guide](https://helm.sh/docs/intro/install/) |
| Docker | Latest | [Guide](https://docs.docker.com/get-docker/) |
| Git | ≥ 2.0 | [Guide](https://git-scm.com/downloads) |

---

## Getting Started

### 1. Configure AWS CLI

```bash
aws configure
# Enter: Access Key ID, Secret Access Key, Region, Output format
```

### 2. Clone the Repository

```bash
git clone https://github.com/nithingowdahm87/eks-ecommerce-gitops.git
cd eks-ecommerce-gitops
```

### 3. Choose Your Deployment Strategy

> [!IMPORTANT]
> **Main Branch** — Uses public Docker images (`nithin/nithin-shop-*:v1.0`). Ideal for learning, demos, and testing. No GitHub Actions required.
>
> **GitOps Branch** — Full production workflow. Uses private ECR images, auto-built on every commit via GitHub Actions. Requires GitHub Secrets setup (see [CI/CD Pipeline](#cicd-pipeline)).

---

## Terraform Deployment

The infrastructure is deployed in **two phases** for safe, ordered provisioning.

### Phase 1 — EKS Cluster & VPC

```bash
cd terraform/
terraform init
terraform apply \
  -target=module.retail_app_eks \
  -target=module.vpc \
  --auto-approve
```

This provisions:
- Custom VPC with public/private subnets
- Amazon EKS cluster with Auto Mode
- Security groups and IAM roles

### Update kubeconfig

Once Phase 1 completes, configure `kubectl` to access the cluster:

```bash
aws eks update-kubeconfig --name nithin-shop-eks --region <your-region>
```

Verify access:

```bash
kubectl get nodes
```

### Phase 2 — GitOps & Ingress Stack

```bash
terraform apply --auto-approve
```

This deploys:
- **ArgoCD** — GitOps operator
- **NGINX Ingress Controller** — External load balancer
- **Cert Manager** — TLS certificate management

---

## GitOps with ArgoCD

All Kubernetes application deployments are managed by **ArgoCD** — no manual `kubectl apply` for application updates.

### Access the ArgoCD UI

```bash
# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d && echo

# Port-forward to local browser
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
```

Open: **https://localhost:8080**
- Username: `admin`
- Password: *(output from command above)*

### ArgoCD Applications

All 5 microservices are registered as individual ArgoCD applications under the `nithin-shop` project:

| App | Source | Target |
|---|---|---|
| `nithin-shop-ui` | `src/ui/chart` | `in-cluster/nithin-shop` |
| `nithin-shop-catalog` | `src/catalog/chart` | `in-cluster/nithin-shop` |
| `nithin-shop-cart` | `src/cart/chart` | `in-cluster/nithin-shop` |
| `nithin-shop-orders` | `src/orders/chart` | `in-cluster/nithin-shop` |
| `nithin-shop-checkout` | `src/checkout/chart` | `in-cluster/nithin-shop` |

ArgoCD continuously reconciles the cluster state to match this repository. Any change merged to `main` is automatically detected and synced.

---

## CI/CD Pipeline

The production workflow uses **GitHub Actions** to build and push images to Amazon ECR automatically on every push to the `gitops` branch.

### Setup GitHub Secrets

Go to your repo → **Settings → Secrets and variables → Actions** and add:

| Secret | Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | Your IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | Your IAM user secret key |
| `AWS_REGION` | e.g., `us-east-1` |
| `AWS_ACCOUNT_ID` | Your 12-digit AWS account ID |

### Pipeline Flow

```
Code Push (gitops branch)
        ↓
GitHub Actions triggered
        ↓
Docker build for changed service(s)
        ↓
Push to Amazon ECR (private)
        ↓
Update Helm chart image tag
        ↓
ArgoCD detects diff → auto-sync
        ↓
Rolling update deployed to EKS
```

> [!NOTE]
> The `main` branch skips CI/CD and uses pre-built public images directly. Only the `gitops` branch triggers GitHub Actions.

---

## Monitoring

The project includes a full observability stack deployed to the cluster.

```bash
# Check monitoring namespace
kubectl get pods -n monitoring

# Access Grafana (port-forward)
kubectl port-forward svc/grafana -n monitoring 3000:80 &
```

Open: **http://localhost:3000** (default credentials in the Grafana secret)

Pre-configured dashboards cover:
- Kubernetes cluster node and pod metrics
- Per-service request rates, latency, and error rates
- EKS Auto Mode node pool utilization

See [MONITORING_ACCESS.md](./MONITORING_ACCESS.md) for full dashboard setup.

---

## Verify Deployment

```bash
# Check all pods
kubectl get pods -n nithin-shop

# Check services
kubectl get svc -n nithin-shop

# Get ingress / external load balancer URL
kubectl get svc -n ingress-nginx

# Check ArgoCD application sync status
kubectl get applications -n argocd
```

Use the `EXTERNAL-IP` from the ingress-nginx-controller service to access the storefront in your browser.

---

## Cleanup

Destroy all AWS resources when done to avoid charges.

### Phase 1 — Remove EKS Cluster

```bash
terraform destroy -target=module.retail_app_eks --auto-approve
```

### Phase 2 — Remove Remaining Resources

```bash
terraform destroy --auto-approve
```

> [!NOTE]
> ECR repositories must be deleted manually from the AWS Console — Terraform does not destroy non-empty registries by default.

---

## Troubleshooting

### Image Pull Errors

```
Error: Failed to pull image "nithin/nithin-shop-ui:v1.0"
```

- **Main branch**: Verify the image tag exists on Docker Hub under `nithin/` namespace
- **GitOps branch**: Check GitHub Actions completed successfully and ECR push succeeded
- Confirm `kubectl get secret` shows a valid image pull secret in the `nithin-shop` namespace

### ArgoCD Out of Sync

```bash
# Force a manual sync
argocd app sync nithin-shop-ui

# Or via kubectl
kubectl patch application nithin-shop-ui -n argocd \
  --type merge -p '{"operation":{"sync":{}}}'
```

### Nodes Not Ready

```bash
kubectl describe node <node-name>
# Check for EKS Auto Mode node pool events
kubectl get events -n kube-system --sort-by='.lastTimestamp'
```

### GitHub Actions Not Triggering

1. Confirm you pushed to the `gitops` branch, not `main`
2. Verify all 4 GitHub Secrets are set correctly
3. Check **Actions** tab in the repo for workflow run logs

---

## Project Structure

```
eks-ecommerce-gitops/
├── src/
│   ├── ui/           # Java frontend + Helm chart
│   ├── catalog/      # Go catalog API + Helm chart
│   ├── cart/         # Java cart API + Helm chart
│   ├── orders/       # Java orders API + Helm chart
│   └── checkout/     # Node.js checkout API + Helm chart
├── terraform/        # All AWS infrastructure (EKS, VPC, ArgoCD, Ingress)
├── argocd/           # ArgoCD Application manifests
├── docs/             # Architecture diagrams and screenshots
├── BRANCHING_STRATEGY.md
├── MONITORING_ACCESS.md
└── README.md
```

---

## License

This project is licensed under the **Apache License 2.0** — see the [LICENSE](./LICENSE) file for details.

---

<div align="center">
  Built with ☕ and a lot of <code>kubectl get pods</code> by <a href="https://github.com/nithingowdahm87">NITHIN</a>
</div>
