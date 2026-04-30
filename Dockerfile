# Multi-stage build for Mesón Santa Rosa static website
# Stage 1: Build stage (minimal, just for organization)
FROM nginx:alpine AS builder

# Stage 2: Production stage
FROM nginx:alpine

# Set metadata
LABEL maintainer="Mesón Santa Rosa"
LABEL description="Static website for Mesón Santa Rosa Hotel Boutique"
LABEL version="1.0"
LABEL org.opencontainers.image.source https://github.com/antoniosolismz/New-Meson-Website

# Remove default nginx configuration and website
RUN rm -rf /usr/share/nginx/html/* && \
    rm /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy website files to nginx html directory
COPY index.html /usr/share/nginx/html/
COPY 404.html /usr/share/nginx/html/
COPY privacidad.html /usr/share/nginx/html/
COPY terminos.html /usr/share/nginx/html/
COPY logo_meson_estampa.png /usr/share/nginx/html/
COPY favicon.svg /usr/share/nginx/html/
COPY robots.txt /usr/share/nginx/html/
COPY sitemap.xml /usr/share/nginx/html/

# Copy optimized assets directory
COPY assets/optimized /usr/share/nginx/html/assets/optimized

# Set proper permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
