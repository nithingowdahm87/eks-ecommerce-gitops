# ArgoCD — GitOps Application Manifests

This directory contains all ArgoCD resources for the `nithin-shop` project.

## Structure

```
argocd/
├── projects/          # ArgoCD AppProject definition (nithin-shop)
└── applications/      # One Application manifest per microservice
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
- **Sync policy**: ArgoCD watches for Git diff and syncs automatically (`prune: true`, `selfHeal: true`)
- **Sync wave**: services are deployed in order using `argocd.argoproj.io/sync-wave` annotations

## Example — nithin-shop-ui

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nithin-shop-ui
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "2"
spec:
  project: nithin-shop
  source:
    repoURL: https://github.com/nithingowdahm87/eks-ecommerce-gitops
    targetRevision: main
    path: src/ui/chart
    helm:
      valueFiles:
        - values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: nithin-shop
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

## Applying manually

If ArgoCD is already running in your cluster:

```bash
kubectl apply -f argocd/projects/
kubectl apply -f argocd/applications/
```

ArgoCD will immediately begin syncing all 5 services to the `nithin-shop` namespace.

## ArgoCD Applications

| App | Helm Chart Path | Namespace | Sync |
|---|---|---|---|
| `nithin-shop-ui` | `src/ui/chart` | `nithin-shop` | Automated |
| `nithin-shop-catalog` | `src/catalog/chart` | `nithin-shop` | Automated |
| `nithin-shop-cart` | `src/cart/chart` | `nithin-shop` | Automated |
| `nithin-shop-orders` | `src/orders/chart` | `nithin-shop` | Automated |
| `nithin-shop-checkout` | `src/checkout/chart` | `nithin-shop` | Automated |
