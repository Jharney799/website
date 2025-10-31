#!/bin/bash
# SCP deployment script for james-harney.com
# Run this from your local machine

# ===== CONFIGURATION =====
SERVER_USER="your-username"        # Change to your server username
SERVER_HOST="your-server-ip"       # Change to your Vultr server IP or hostname
REMOTE_TMP="/tmp/website-upload"
REMOTE_WEB="/var/www/htdocs/james-harney"
# =========================

set -e

echo "=== Deploying james-harney.com via SCP ==="

# Check if htdocs exists
if [ ! -d "htdocs" ]; then
    echo "Error: htdocs directory not found. Run this script from the website root directory."
    exit 1
fi

echo "Uploading website files to $SERVER_HOST..."
ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p $REMOTE_TMP"
scp -r htdocs/* "$SERVER_USER@$SERVER_HOST:$REMOTE_TMP/"

echo "Uploading configuration files..."
scp httpd.conf "$SERVER_USER@$SERVER_HOST:$REMOTE_TMP/"

echo "Installing files on server..."
ssh "$SERVER_USER@$SERVER_HOST" << 'ENDSSH'
    echo "Creating web directory..."
    doas mkdir -p /var/www/htdocs/james-harney

    echo "Copying website files..."
    doas cp -r /tmp/website-upload/* /var/www/htdocs/james-harney/

    echo "Setting permissions..."
    doas chown -R www:www /var/www/htdocs/james-harney
    doas chmod -R 755 /var/www/htdocs/james-harney

    echo "Cleaning up temporary files..."
    rm -rf /tmp/website-upload

    echo "Restarting web services..."
    doas rcctl restart httpd
    doas rcctl restart php_fpm || true
ENDSSH

echo ""
echo "=== Deployment complete! ==="
echo "Your website should now be live at http://$SERVER_HOST"
echo ""
echo "Next steps:"
echo "1. Visit http://$SERVER_HOST to verify the site is working"
echo "2. Check logs: ssh $SERVER_USER@$SERVER_HOST 'tail -f /var/www/logs/james-harney.access.log'"
echo "3. Set up HTTPS with Let's Encrypt (see DEPLOYMENT.md)"
