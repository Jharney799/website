# Deployment Guide for james-harney.com on OpenBSD/Vultr

## Prerequisites
- Vultr VPS running OpenBSD
- Root or doas access
- Domain name pointed to your server IP

## Setup Instructions

### 1. Install Required Packages

```sh
doas pkg_add php php-fpm
```

### 2. Configure httpd

Copy the httpd configuration:

```sh
doas cp httpd.conf /etc/httpd.conf
```

Edit `/etc/httpd.conf` and update:
- `ext_ip` with your server's IP address (or keep as "*" for all interfaces)
- `domain` with your actual domain name

### 3. Set Up Web Directory

```sh
# Create website directory
doas mkdir -p /var/www/htdocs/james-harney

# Copy website files
doas cp -r htdocs/* /var/www/htdocs/james-harney/

# Set proper permissions
doas chown -R www:www /var/www/htdocs/james-harney
doas chmod -R 755 /var/www/htdocs/james-harney
```

### 4. Configure PHP-FPM

Edit `/etc/php-fpm.conf` and ensure the socket path matches:

```ini
listen = /var/www/run/php-fpm.sock
listen.owner = www
listen.group = www
listen.mode = 0660
```

Enable PHP mail function by editing `/etc/php-8.x.ini`:

```ini
sendmail_path = /usr/sbin/sendmail -t -i
```

### 5. Enable and Start Services

```sh
# Enable services to start on boot
doas rcctl enable httpd php_fpm

# Start services
doas rcctl start php_fpm
doas rcctl start httpd
```

### 6. Test Configuration

```sh
# Check httpd configuration
doas httpd -n

# Check if services are running
doas rcctl check httpd
doas rcctl check php_fpm
```

### 7. Firewall Configuration (if using PF)

Add to `/etc/pf.conf`:

```
# Allow HTTP/HTTPS traffic
pass in on egress proto tcp to port { 80 443 } keep state
```

Reload PF:

```sh
doas pfctl -f /etc/pf.conf
```

### 8. DNS Configuration

Ensure your domain DNS has an A record pointing to your Vultr server IP:

```
james-harney.com.    A    <your-vultr-ip>
www.james-harney.com A    <your-vultr-ip>
```

## SSL/TLS Setup (Recommended)

For HTTPS support using Let's Encrypt:

```sh
# Install acme-client (included in base OpenBSD)
# Update httpd.conf to include HTTPS server block
# Request certificate
doas acme-client -v james-harney.com
```

## Deploying Website Files to Server

### Method 1: SCP from Local Machine (Recommended)

From your local machine where you have the website code:

```sh
# Upload website files
scp -r htdocs/* user@your-server-ip:/tmp/website-upload/

# Then on the server:
doas cp -r /tmp/website-upload/* /var/www/htdocs/james-harney/
doas chown -R www:www /var/www/htdocs/james-harney
rm -rf /tmp/website-upload
```

Or use the included `deploy-scp.sh` script:

```sh
# Edit deploy-scp.sh to set your server IP/hostname
./deploy-scp.sh
```

### Method 2: Manual Upload via SFTP

Use an SFTP client (like FileZilla, Cyberduck, or WinSCP) to upload the contents of the `htdocs/` directory to your server at `/var/www/htdocs/james-harney/`

After upload, SSH to your server and set permissions:

```sh
doas chown -R www:www /var/www/htdocs/james-harney
doas chmod -R 755 /var/www/htdocs/james-harney
```

### Method 3: Using Git (Optional)

If you want to use git on the server:

```sh
# On OpenBSD server, install git
doas pkg_add git

# Clone your repository
cd /tmp
git clone https://github.com/Jharney799/website.git
cd website
doas cp -r htdocs/* /var/www/htdocs/james-harney/
doas chown -R www:www /var/www/htdocs/james-harney

# For future updates
cd /tmp/website
git pull
doas cp -r htdocs/* /var/www/htdocs/james-harney/
```

## Troubleshooting

### Check logs
```sh
tail -f /var/www/logs/james-harney.access.log
tail -f /var/www/logs/james-harney.error.log
```

### Test PHP
Create a test file:
```sh
echo "<?php phpinfo(); ?>" | doas tee /var/www/htdocs/james-harney/test.php
```
Visit: http://your-domain/test.php

### Restart services
```sh
doas rcctl restart httpd
doas rcctl restart php_fpm
```

## Contact Form Notes

The contact form uses PHP's `mail()` function. Ensure your OpenBSD server has a working mail setup (sendmail/smtpd configured) or the emails won't be delivered.

Alternative: Consider using a service like SendGrid or Mailgun for more reliable email delivery.
