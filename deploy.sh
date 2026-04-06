#!/bin/bash
# Quick deployment script for Mesón Santa Rosa
# This script builds and deploys the Docker container

set -e

echo "🏨 Mesón Santa Rosa - Docker Deployment Script"
echo "=============================================="
echo ""

# Configuration
CONTAINER_NAME="meson-santa-rosa-web"
IMAGE_NAME="meson-santa-rosa:latest"
PORT="${1:-8080}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Stop and remove existing container if it exists
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "🛑 Stopping existing container..."
    docker stop ${CONTAINER_NAME} >/dev/null 2>&1 || true
    echo "🗑️  Removing existing container..."
    docker rm ${CONTAINER_NAME} >/dev/null 2>&1 || true
fi

# Build the image
echo "🔨 Building Docker image..."
docker build -t ${IMAGE_NAME} . || {
    echo "❌ Build failed!"
    exit 1
}

echo "✅ Image built successfully!"
echo ""

# Run the container
echo "🚀 Starting container on port ${PORT}..."
docker run -d \
    --name ${CONTAINER_NAME} \
    -p ${PORT}:80 \
    --restart unless-stopped \
    ${IMAGE_NAME}

echo "✅ Container started successfully!"
echo ""
echo "📊 Container Status:"
docker ps --filter "name=${CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "🌐 Website available at: http://localhost:${PORT}"
echo ""
echo "📝 Useful commands:"
echo "  View logs:    docker logs -f ${CONTAINER_NAME}"
echo "  Stop:         docker stop ${CONTAINER_NAME}"
echo "  Start:        docker start ${CONTAINER_NAME}"
echo "  Restart:      docker restart ${CONTAINER_NAME}"
echo "  Remove:       docker stop ${CONTAINER_NAME} && docker rm ${CONTAINER_NAME}"
echo ""
echo "✨ Deployment complete!"
