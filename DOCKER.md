# Docker Deployment Guide - Mesón Santa Rosa

This guide explains how to build and deploy the Mesón Santa Rosa website using Docker.

---

## Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
# Build and start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

The website will be available at: `http://localhost:8080`

### Option 2: Using Docker CLI

```bash
# Build the image
docker build -t meson-santa-rosa:latest .

# Run the container
docker run -d \
  --name meson-santa-rosa-web \
  -p 8080:80 \
  --restart unless-stopped \
  meson-santa-rosa:latest

# View logs
docker logs -f meson-santa-rosa-web

# Stop and remove container
docker stop meson-santa-rosa-web
docker rm meson-santa-rosa-web
```

---

## Deployment to Proxmox

### Prerequisites

1. Proxmox server with Docker installed
2. SSH access to your Proxmox host or container
3. Network connectivity to your Proxmox server

### Method 1: Build on Proxmox

```bash
# 1. Copy project files to Proxmox
scp -r /home/otelo/Documents/Code/new-meson-santa-rosa root@proxmox-ip:/opt/

# 2. SSH into Proxmox
ssh root@proxmox-ip

# 3. Navigate to project directory
cd /opt/new-meson-santa-rosa

# 4. Build and run with docker-compose
docker-compose up -d
```

### Method 2: Build Locally, Push to Registry

```bash
# 1. Build the image locally
docker build -t meson-santa-rosa:latest .

# 2. Save image to tar file
docker save meson-santa-rosa:latest -o meson-santa-rosa.tar

# 3. Copy to Proxmox
scp meson-santa-rosa.tar root@proxmox-ip:/tmp/

# 4. SSH into Proxmox and load image
ssh root@proxmox-ip
docker load -i /tmp/meson-santa-rosa.tar

# 5. Run the container
docker run -d \
  --name meson-santa-rosa-web \
  -p 80:80 \
  --restart unless-stopped \
  meson-santa-rosa:latest
```

### Method 3: Using Docker Registry (Advanced)

```bash
# 1. Tag the image for your registry
docker tag meson-santa-rosa:latest your-registry.com/meson-santa-rosa:latest

# 2. Push to registry
docker push your-registry.com/meson-santa-rosa:latest

# 3. On Proxmox, pull and run
ssh root@proxmox-ip
docker pull your-registry.com/meson-santa-rosa:latest
docker run -d \
  --name meson-santa-rosa-web \
  -p 80:80 \
  --restart unless-stopped \
  your-registry.com/meson-santa-rosa:latest
```

---

## Port Configuration

By default, the container exposes port 80 internally. You can map it to any port on your host:

```bash
# Use port 8080
docker run -p 8080:80 meson-santa-rosa:latest

# Use port 80 (requires root/sudo)
docker run -p 80:80 meson-santa-rosa:latest

# Use port 3000
docker run -p 3000:80 meson-santa-rosa:latest
```

For Proxmox deployments behind a reverse proxy (like Nginx Proxy Manager or Traefik), you can use any available port and configure the proxy to forward traffic.

---

## Reverse Proxy Configuration

### Nginx Proxy Manager (GUI)

1. Add a new Proxy Host
2. Set domain name (e.g., `meonsantarosa.com`)
3. Forward to: `<container-ip>:80`
4. Enable SSL if needed

### Nginx (Manual)

```nginx
server {
    listen 80;
    server_name meonsantarosa.com www.meonsantarosa.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Traefik Labels

If using Traefik, add these labels to `docker-compose.yml`:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.meson.rule=Host(`meonsantarosa.com`)"
  - "traefik.http.services.meson.loadbalancer.server.port=80"
```

---

## Management Commands

```bash
# View container status
docker ps

# View logs
docker logs meson-santa-rosa-web

# Follow logs in real-time
docker logs -f meson-santa-rosa-web

# Restart container
docker restart meson-santa-rosa-web

# Stop container
docker stop meson-santa-rosa-web

# Start container
docker start meson-santa-rosa-web

# Remove container
docker rm meson-santa-rosa-web

# Remove image
docker rmi meson-santa-rosa:latest

# Check health status
docker inspect --format='{{.State.Health.Status}}' meson-santa-rosa-web

# Execute command inside container
docker exec -it meson-santa-rosa-web sh
```

---

## Updating the Website

When you make changes to the website:

```bash
# 1. Stop and remove old container
docker-compose down
# OR
docker stop meson-santa-rosa-web && docker rm meson-santa-rosa-web

# 2. Rebuild image with new changes
docker-compose build
# OR
docker build -t meson-santa-rosa:latest .

# 3. Start new container
docker-compose up -d
# OR
docker run -d --name meson-santa-rosa-web -p 8080:80 --restart unless-stopped meson-santa-rosa:latest
```

---

## Troubleshooting

### Container won't start

```bash
# Check logs
docker logs meson-santa-rosa-web

# Check if port is already in use
sudo netstat -tulpn | grep :8080
# OR
sudo ss -tulpn | grep :8080
```

### Website not accessible

```bash
# Verify container is running
docker ps | grep meson

# Check container health
docker inspect --format='{{.State.Health.Status}}' meson-santa-rosa-web

# Test from inside container
docker exec meson-santa-rosa-web wget -O- http://localhost/
```

### Permission issues on Proxmox

```bash
# Ensure Docker daemon is running
systemctl status docker

# Check SELinux/AppArmor if enabled
sestatus
# OR
aa-status
```

---

## Image Details

- **Base Image**: nginx:alpine
- **Size**: ~141 MB (includes optimized images only, originals excluded)
- **Exposed Port**: 80
- **Health Check**: HTTP GET to `/` every 30 seconds
- **Restart Policy**: unless-stopped
- **Note**: Original unoptimized images (349 MB) are excluded to reduce size

---

## Security Notes

1. The image includes security headers in Nginx configuration
2. Hidden files (dotfiles) are blocked by Nginx
3. Container runs as non-root user (nginx)
4. Only necessary files are included (see `.dockerignore`)

---

## Performance Optimizations

- Gzip compression enabled for text resources
- Static asset caching configured (1 year for images, 1 month for CSS/JS)
- Alpine Linux base for minimal image size
- Health checks for container orchestration

---

## Support

For issues or questions, refer to the main README.md or AGENTS.md files.
