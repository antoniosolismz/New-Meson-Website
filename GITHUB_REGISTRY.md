# GitHub Container Registry (GHCR) Setup Guide

This guide shows you how to push your Mesón Santa Rosa Docker image to GitHub Container Registry (GHCR) and pull it from Proxmox.

---

## Why GitHub Container Registry?

- ✅ **Free** for public and private repositories
- ✅ **Unlimited** private images for personal accounts
- ✅ **No expiration** - images stay forever
- ✅ **Easy authentication** with GitHub tokens
- ✅ **Integrated** with your GitHub account
- ✅ **OCI compliant** - works with Proxmox 9.1+

---

## Prerequisites

1. GitHub account (free or paid)
2. Docker installed locally
3. Personal Access Token (PAT) from GitHub

---

## Step 1: Create GitHub Personal Access Token

1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Direct link: https://github.com/settings/tokens

2. Click **"Generate new token"** → **"Generate new token (classic)"**

3. Configure the token:
   - **Note**: `Proxmox GHCR Access` (or any descriptive name)
   - **Expiration**: Choose duration (recommend 90 days or 1 year)
   - **Select scopes**:
     - ✅ `write:packages` (includes read and delete)
     - ✅ `read:packages` (automatically selected)
     - ✅ `delete:packages` (automatically selected)

4. Click **"Generate token"**

5. **IMPORTANT**: Copy the token immediately and save it securely
   - Format: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   - You won't be able to see it again!

---

## Step 2: Login to GitHub Container Registry

Open your terminal and login to GHCR:

```bash
# Login to GHCR
echo "YOUR_GITHUB_TOKEN" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

**Example:**
```bash
# If your GitHub username is "johndoe" and token is "ghp_abc123..."
echo "ghp_abc123..." | docker login ghcr.io -u johndoe --password-stdin
```

You should see:
```
Login Succeeded
```

---

## Step 3: Tag Your Image for GHCR

Images on GHCR use this format:
```
ghcr.io/GITHUB_USERNAME/IMAGE_NAME:TAG
```

Tag your Mesón Santa Rosa image:

```bash
# Navigate to your project directory
cd /home/otelo/Documents/Code/new-meson-santa-rosa

# Tag the image
docker tag meson-santa-rosa:latest ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:latest

# Optional: Also tag with a version
docker tag meson-santa-rosa:latest ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:v1.0
```

**Example:**
```bash
docker tag meson-santa-rosa:latest ghcr.io/johndoe/meson-santa-rosa:latest
docker tag meson-santa-rosa:latest ghcr.io/johndoe/meson-santa-rosa:v1.0
```

---

## Step 4: Push Image to GHCR

Push your tagged image:

```bash
# Push latest tag
docker push ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:latest

# Push version tag (if you created it)
docker push ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:v1.0
```

This will take a few minutes depending on your internet speed (~872 MB).

You should see output like:
```
The push refers to repository [ghcr.io/johndoe/meson-santa-rosa]
abc123def456: Pushed
...
latest: digest: sha256:... size: 1234
```

---

## Step 5: Make Package Public or Private

By default, packages are **private**. To change visibility:

1. Go to GitHub → Your profile → Packages
   - Direct link: https://github.com/YOUR_USERNAME?tab=packages

2. Click on **meson-santa-rosa** package

3. Click **Package settings** (right sidebar)

4. Scroll to **Danger Zone**

5. Choose:
   - **Private**: Only you can access (requires authentication)
   - **Public**: Anyone can pull (no authentication needed)

**For private website**, keep it **Private**.

---

## Step 6: Pull Image in Proxmox 9.1+

### Option A: Public Image (No Authentication)

If you made the package public:

1. In Proxmox, navigate to your storage
2. Click **"Pull from OCI Registry"**
3. Enter the image URL:
   ```
   docker://ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:latest
   ```
4. Click **Download**

### Option B: Private Image (With Authentication)

If your package is private, you need to authenticate.

**On Proxmox host, via SSH:**

```bash
# Login to GHCR from Proxmox
echo "YOUR_GITHUB_TOKEN" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

**Then in Proxmox Web UI:**

1. Navigate to your storage
2. Click **"Pull from OCI Registry"**
3. Enter the image URL:
   ```
   docker://ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:latest
   ```
4. Click **Download**

---

## Step 7: Create Container from OCI Image

Once the image is pulled:

1. Click **"Create CT"** in Proxmox
2. Fill in the **General** tab (hostname, password, etc.)
3. On **Template** tab, select your OCI image:
   ```
   ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:latest
   ```
4. Configure **CPU**, **Memory**, **Network** as needed
5. Click **Create**

Your website will now be running!

---

## Complete Example Workflow

Here's a complete example assuming GitHub username is `johndoe`:

```bash
# 1. Login to GHCR
echo "ghp_abc123xyz..." | docker login ghcr.io -u johndoe --password-stdin

# 2. Build image (if not already built)
docker build -t meson-santa-rosa:latest .

# 3. Tag for GHCR
docker tag meson-santa-rosa:latest ghcr.io/johndoe/meson-santa-rosa:latest

# 4. Push to GHCR
docker push ghcr.io/johndoe/meson-santa-rosa:latest

# 5. Verify it's uploaded
# Go to: https://github.com/johndoe?tab=packages

# 6. On Proxmox (via SSH)
ssh root@proxmox-ip
echo "ghp_abc123xyz..." | docker login ghcr.io -u johndoe --password-stdin

# 7. In Proxmox Web UI: Pull from OCI Registry
# URL: docker://ghcr.io/johndoe/meson-santa-rosa:latest
```

---

## Quick Reference Script

Save this as `push-to-ghcr.sh`:

```bash
#!/bin/bash
# Push Mesón Santa Rosa to GitHub Container Registry

# Configuration
GITHUB_USERNAME="YOUR_GITHUB_USERNAME"
IMAGE_NAME="meson-santa-rosa"
GHCR_IMAGE="ghcr.io/${GITHUB_USERNAME}/${IMAGE_NAME}"

echo "🐙 Pushing to GitHub Container Registry"
echo "========================================"
echo ""

# Check if logged in
if ! docker info 2>/dev/null | grep -q "ghcr.io"; then
    echo "⚠️  Not logged in to GHCR"
    echo "Please run:"
    echo "  echo 'YOUR_TOKEN' | docker login ghcr.io -u ${GITHUB_USERNAME} --password-stdin"
    exit 1
fi

# Tag image
echo "🏷️  Tagging image..."
docker tag ${IMAGE_NAME}:latest ${GHCR_IMAGE}:latest || exit 1

# Push image
echo "📤 Pushing to GHCR..."
docker push ${GHCR_IMAGE}:latest || exit 1

echo ""
echo "✅ Successfully pushed to GHCR!"
echo ""
echo "📦 Image URL: ${GHCR_IMAGE}:latest"
echo "🌐 View at: https://github.com/${GITHUB_USERNAME}?tab=packages"
echo ""
echo "📋 Proxmox Pull URL:"
echo "   docker://${GHCR_IMAGE}:latest"
echo ""
```

Make it executable:
```bash
chmod +x push-to-ghcr.sh
```

---

## Updating the Image

When you make changes to your website:

```bash
# 1. Rebuild image
docker build -t meson-santa-rosa:latest .

# 2. Tag and push to GHCR
docker tag meson-santa-rosa:latest ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:latest
docker push ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:latest

# 3. In Proxmox: Pull the updated image again
# 4. Recreate container with new image
```

---

## Troubleshooting

### "unauthorized: unauthenticated" Error

You're not logged in. Run:
```bash
echo "YOUR_TOKEN" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
```

### "denied: permission_denied" Error

Your token doesn't have the right permissions. Create a new token with:
- ✅ `write:packages`
- ✅ `read:packages`

### Can't Pull in Proxmox

1. Make sure you're logged in on Proxmox host:
   ```bash
   ssh root@proxmox-ip
   docker login ghcr.io
   ```

2. Use the correct URL format:
   ```
   docker://ghcr.io/username/image:tag
   ```
   Note the `docker://` prefix!

### Image Not Found

Check:
1. GitHub username spelling
2. Image name spelling
3. Package visibility (private vs public)
4. You're logged in (if private)

### Push Takes Too Long

The image is ~141 MB. On a slow connection this can take 3-5 minutes. Be patient!

---

## Security Best Practices

1. **Never commit tokens to Git**
   - Add to `.gitignore` if storing in files
   - Use environment variables

2. **Set token expiration**
   - Don't use "no expiration"
   - Set reminder to rotate tokens

3. **Use minimal permissions**
   - Only `write:packages` is needed
   - Don't add extra scopes

4. **Keep packages private**
   - Unless you want the website public
   - Private is free on GitHub

5. **Rotate tokens regularly**
   - Every 90 days recommended
   - Delete old tokens

---

## Cost

**FREE** for:
- ✅ Unlimited public packages
- ✅ Unlimited private packages (personal accounts)
- ✅ 500 MB storage for private (free tier)
- ✅ 1 GB bandwidth/month (free tier)

Your image is ~141 MB, which fits comfortably within the free tier for private packages!

Even better, if you make it **public**, you get unlimited storage and bandwidth at no cost.

---

## Summary

✅ Your image URL will be:
```
ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:latest
```

✅ In Proxmox, use:
```
docker://ghcr.io/YOUR_GITHUB_USERNAME/meson-santa-rosa:latest
```

✅ Free, unlimited, and integrated with GitHub!

---

**Next Steps:**
1. Create GitHub Personal Access Token
2. Login to GHCR locally
3. Tag and push your image
4. Login to GHCR on Proxmox
5. Pull image in Proxmox Web UI
6. Create container and enjoy!
