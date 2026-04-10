# ArgoCD — GitOps Application Manifests

This directory contains all ArgoCD resources for the `nithin-shop` project.

## Structure

```text
argocd/
├── projects/       # ArgoCD AppProject definition (nithin-shop)
└── applications/   # One Application manifest per microservice
    ├── nithin-shop-ui.yaml
    ├── nithin-shop-catalog.yaml
    ├── nithin-shop-cart.yaml
    ├── nithin-shop-orders.yaml
    └── nithin-shop-checkout.yaml
```

## How it works

Each `Application` manifest tells ArgoCD:
- **Source**: which path in this repo holds the Helm chart (`src/<service>/chart`)
- **Destination**: `in-cluster` Kubernetes cluster, namespace `nithin-shop`
- **Sync policy**: ArgoCD watches for Git diff and syncs automatically

## Example — nithin-shop-ui

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nithin-shop-ui
  namespace: argocd
spec:
  project: nithin-shop
  source:
    repoURL: https://github.com/nithingowdahm87/eks-ecommerce-gitops
    targetRevision: main
    path: src/ui/chart
  destination:
    server: https://kubernetes.default.svc
    namespace: nithin-shop
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## Applying manually

If ArgoCD is already running in your cluster:

```bash
kubectl apply -f argocd/projects/
kubectl apply -f argocd/applications/
```

ArgoCD will immediately begin syncing all 5 services to the `nithin-shop` namespace.
