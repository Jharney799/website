#!/bin/sh
# Git-based deployment script for james-harney.com
# Run this on your OpenBSD server

set -e

SITE_DIR="/var/www/htdocs/james-harney"
REPO_URL="https://github.com/Jharney799/website.git"

echo "=== Deploying james-harney.com ==="

# Check if git is installed
if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is not installed."
    echo "Install with: doas pkg_add git"
    exit 1
fi

# If site directory doesn't exist or isn't a git repo, clone it
if [ ! -d "$SITE_DIR/.git" ]; then
    echo "Initial setup: cloning repository into $SITE_DIR..."
    doas mkdir -p "$SITE_DIR"
    doas git clone "$REPO_URL" "$SITE_DIR"
else
    # Pull latest changes
    echo "Pulling latest changes..."
    cd "$SITE_DIR"
    doas git pull
fi

# Set permissions
echo "Setting permissions..."
doas chown -R www:www "$SITE_DIR"
doas chmod -R 755 "$SITE_DIR"

# Restart services
echo "Restarting web services..."
doas rcctl restart php_fpm 2>/dev/null || true
doas rcctl restart httpd

echo ""
echo "=== Deployment complete! ==="
echo "Your site is now live!"
echo ""
echo "To update in the future, just run this script again or:"
echo "  cd $SITE_DIR && doas git pull"
