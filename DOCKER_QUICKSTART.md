# Quick Reference - Docker Deployment

## 🚀 Quick Start Commands

### Local Testing
```bash
# Build and run (port 8080)
./deploy.sh

# Or use docker-compose
docker-compose up -d
```

### Deploy to Proxmox

#### Method 1: Copy files and build on Proxmox
```bash
# Copy project to Proxmox
scp -r /home/otelo/Documents/Code/new-meson-santa-rosa root@YOUR_PROXMOX_IP:/opt/

# SSH into Proxmox
ssh root@YOUR_PROXMOX_IP

# Navigate and deploy
cd /opt/new-meson-santa-rosa
./deploy.sh 80
```

#### Method 2: Build locally, transfer image
```bash
# Save image to file
docker save meson-santa-rosa:latest | gzip > meson-santa-rosa.tar.gz

# Transfer to Proxmox
scp meson-santa-rosa.tar.gz root@YOUR_PROXMOX_IP:/tmp/

# On Proxmox: Load and run
ssh root@YOUR_PROXMOX_IP
gunzip -c /tmp/meson-santa-rosa.tar.gz | docker load
docker run -d --name meson-santa-rosa-web -p 80:80 --restart unless-stopped meson-santa-rosa:latest
```

---

## 📦 What Was Created

| File | Purpose |
|------|---------|
| `Dockerfile` | Docker image definition (Nginx Alpine) |
| `nginx.conf` | Nginx server configuration |
| `.dockerignore` | Files to exclude from image |
| `docker-compose.yml` | Docker Compose orchestration |
| `deploy.sh` | Quick deployment script |
| `DOCKER.md` | Complete documentation |

---

## 🎯 Common Commands

```bash
# Build image
docker build -t meson-santa-rosa:latest .

# Run container (port 8080)
docker run -d --name meson-santa-rosa-web -p 8080:80 --restart unless-stopped meson-santa-rosa:latest

# View logs
docker logs -f meson-santa-rosa-web

# Stop/Start/Restart
docker stop meson-santa-rosa-web
docker start meson-santa-rosa-web
docker restart meson-santa-rosa-web

# Check status
docker ps | grep meson

# Access shell inside container
docker exec -it meson-santa-rosa-web sh

# Remove container
docker stop meson-santa-rosa-web && docker rm meson-santa-rosa-web

# Remove image
docker rmi meson-santa-rosa:latest
```

---

## 🔧 Port Configuration

The container exposes port 80 internally. Map it to any host port:

```bash
# Port 80 (standard HTTP)
docker run -p 80:80 ...

# Port 8080
docker run -p 8080:80 ...

# Port 3000
docker run -p 3000:80 ...
```

---

## 🏥 Health & Monitoring

```bash
# Check health status
docker inspect --format='{{.State.Health.Status}}' meson-santa-rosa-web

# Test website response
curl -I http://localhost:8080

# View container stats
docker stats meson-santa-rosa-web
```

---

## 🔄 Updating the Website

When you make changes:

```bash
# 1. Stop and remove old container
docker stop meson-santa-rosa-web
docker rm meson-santa-rosa-web

# 2. Rebuild image
docker build -t meson-santa-rosa:latest .

# 3. Start new container
docker run -d --name meson-santa-rosa-web -p 8080:80 --restart unless-stopped meson-santa-rosa:latest
```

Or use the deploy script:
```bash
./deploy.sh
```

---

## 📝 Image Specifications

- **Base**: nginx:alpine
- **Size**: ~141 MB (optimized images only)
- **Port**: 80
- **Features**:
  - Gzip compression
  - Static asset caching (1 year for images, 1 month for CSS/JS)
  - Security headers
  - Custom 404 page
  - Health checks
- **Note**: Original unoptimized images excluded for smaller size

---

## 🌐 Reverse Proxy Setup

If using Nginx Proxy Manager on Proxmox:

1. Add new Proxy Host
2. Domain: `mesonsantarosa.com.mx`
3. Forward to: `container-ip:80` or `localhost:PORT`
4. Enable "Block Common Exploits"
5. Add SSL certificate

---

## ⚠️ Troubleshooting

### Container won't start
```bash
docker logs meson-santa-rosa-web
```

### Port already in use
```bash
# Find what's using the port
sudo netstat -tulpn | grep :8080
# Or use a different port
./deploy.sh 8081
```

### Test from inside container
```bash
docker exec meson-santa-rosa-web wget -O- http://localhost/
```

---

## 📚 Full Documentation

See `DOCKER.md` for complete documentation including:
- Detailed deployment methods
- Reverse proxy configurations
- Security notes
- Performance optimizations
- Advanced troubleshooting

---

**✨ Ready to deploy!**
