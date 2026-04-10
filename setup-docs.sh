#!/usr/bin/env bash
# setup-docs.sh — nithin-shop docs restructure
# Run once from the repo root: bash setup-docs.sh
set -e

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_ROOT"

echo "=== nithin-shop docs setup ==="

# 1. Create directories
mkdir -p docs/screenshots docs/images

# 2. Move screenshot JPGs (if they exist at repo root)
for f in app1.jpg app2.jpg app3.jpg app4.jpg app5.jpg app6.jpg app7.jpg argoCD.jpg; do
  if [ -f "$f" ]; then
    git mv "$f" "docs/screenshots/$f"
    echo "Moved $f → docs/screenshots/"
  else
    echo "Skipped $f (not found)"
  fi
done

# 3. Move SVG diagrams (if placed at repo root)
for svg in architecture.svg application-architecture.svg; do
  if [ -f "$svg" ]; then
    git mv "$svg" "docs/images/$svg"
    echo "Moved $svg → docs/images/"
  fi
done

# 4. Remove old/unused PNGs from git
OLD_FILES=(
  docs/images/argocd-ui.png
  docs/images/banner.png
  docs/images/chat-bot-button.png
  docs/images/chat-bot.png
  docs/images/containers.png
  docs/images/metadata-attr-id.png
  docs/images/metadata-attr.png
  docs/images/metadata.png
  docs/images/screenshot.png
  docs/images/theme-default.png
  docs/images/theme-orange.png
  docs/images/EKS.gif
  docs/images/topology.png
)

for f in "${OLD_FILES[@]}"; do
  if git ls-files --error-unmatch "$f" &>/dev/null; then
    git rm "$f"
    echo "Removed $f"
  fi
done

# 5. Stage everything new
git add docs/

# 6. Commit
git commit -m "docs: restructure — add screenshots, SVG diagrams, remove old PNGs"

# 7. Push
git push

echo ""
echo "=== Done! Check https://github.com/nithingowdahm87/eks-ecommerce-gitops ==="
