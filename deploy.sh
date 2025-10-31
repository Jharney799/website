#!/bin/sh
# Quick deployment script for james-harney.com
# Run this on your OpenBSD server

set -e

SITE_DIR="/var/www/htdocs/james-harney"
REPO_URL="https://github.com/Jharney799/website.git"  # Update with your repo URL
TEMP_DIR="/tmp/website-deploy"

echo "=== Deploying james-harney.com ==="

# Clone or pull latest changes
if [ -d "$TEMP_DIR" ]; then
    echo "Pulling latest changes..."
    cd "$TEMP_DIR"
    git pull
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$TEMP_DIR"
    cd "$TEMP_DIR"
fi

# Backup current site
if [ -d "$SITE_DIR" ]; then
    echo "Backing up current site..."
    doas cp -r "$SITE_DIR" "${SITE_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
fi

# Deploy new files
echo "Deploying new files..."
doas mkdir -p "$SITE_DIR"
doas cp -r htdocs/* "$SITE_DIR/"

# Set permissions
echo "Setting permissions..."
doas chown -R www:www "$SITE_DIR"
doas chmod -R 755 "$SITE_DIR"

# Restart services
echo "Restarting web services..."
doas rcctl restart php_fpm
doas rcctl restart httpd

echo "=== Deployment complete! ==="
echo "Visit your site at: http://james-harney.com"
