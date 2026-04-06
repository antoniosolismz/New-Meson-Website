#!/bin/bash
# Push Mesón Santa Rosa to GitHub Container Registry

set -e

# Configuration (UPDATE THESE)
GITHUB_USERNAME="${GITHUB_USERNAME:-YOUR_GITHUB_USERNAME}"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"
IMAGE_NAME="meson-santa-rosa"
GHCR_IMAGE="ghcr.io/${GITHUB_USERNAME}/${IMAGE_NAME}"

echo "🐙 GitHub Container Registry Push Script"
echo "========================================"
echo ""

# Check if username is set
if [ "$GITHUB_USERNAME" = "YOUR_GITHUB_USERNAME" ]; then
    echo "❌ Please set your GitHub username first!"
    echo ""
    echo "Option 1: Edit this script and change GITHUB_USERNAME"
    echo "Option 2: Export environment variable:"
    echo "  export GITHUB_USERNAME='your-username'"
    echo "  ./push-to-ghcr.sh"
    exit 1
fi

# Check if token is provided
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  GitHub token not found in environment"
    echo ""
    read -sp "Enter your GitHub Personal Access Token: " GITHUB_TOKEN
    echo ""
    echo ""
fi

# Login to GHCR
echo "🔐 Logging in to GHCR..."
echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin || {
    echo "❌ Login failed! Check your username and token."
    exit 1
}

echo "✅ Login successful!"
echo ""

# Check if image exists
if ! docker image inspect ${IMAGE_NAME}:latest >/dev/null 2>&1; then
    echo "❌ Image ${IMAGE_NAME}:latest not found locally"
    echo ""
    echo "Building image first..."
    docker build -t ${IMAGE_NAME}:latest . || {
        echo "❌ Build failed!"
        exit 1
    }
fi

# Tag image
echo "🏷️  Tagging image..."
docker tag ${IMAGE_NAME}:latest ${GHCR_IMAGE}:latest || {
    echo "❌ Tagging failed!"
    exit 1
}

# Optional: Tag with version
VERSION=$(date +%Y%m%d)
docker tag ${IMAGE_NAME}:latest ${GHCR_IMAGE}:v${VERSION}
echo "   Tagged as: latest and v${VERSION}"
echo ""

# Push image
echo "📤 Pushing to GHCR (this may take several minutes)..."
docker push ${GHCR_IMAGE}:latest || {
    echo "❌ Push failed!"
    exit 1
}

echo ""
echo "📤 Pushing version tag..."
docker push ${GHCR_IMAGE}:v${VERSION} || {
    echo "⚠️  Version tag push failed (non-critical)"
}

echo ""
echo "✅ Successfully pushed to GitHub Container Registry!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📦 Image URLs:"
echo "   • ${GHCR_IMAGE}:latest"
echo "   • ${GHCR_IMAGE}:v${VERSION}"
echo ""
echo "🌐 View package at:"
echo "   https://github.com/${GITHUB_USERNAME}?tab=packages"
echo ""
echo "📋 For Proxmox, use this URL:"
echo "   docker://${GHCR_IMAGE}:latest"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Go to GitHub and verify package is uploaded"
echo "  2. Set package visibility (public/private)"
echo "  3. On Proxmox: Login to GHCR"
echo "     ssh root@proxmox-ip"
echo "     echo 'YOUR_TOKEN' | docker login ghcr.io -u ${GITHUB_USERNAME} --password-stdin"
echo "  4. In Proxmox Web UI: Pull from OCI Registry"
echo "     URL: docker://${GHCR_IMAGE}:latest"
echo ""
