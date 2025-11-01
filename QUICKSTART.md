# Quick Start - Get Your Website Online in 5 Minutes

This guide assumes you have a fresh OpenBSD VPS on Vultr.

## Step 1: Install Required Packages

SSH into your Vultr VPS:

```sh
# Install PHP and git
doas pkg_add php php-fpm git
```

## Step 2: Clone Website Repository

```sh
# Clone the repository directly into your web directory
doas git clone https://github.com/Jharney799/website.git /var/www/htdocs/james-harney

# Set proper permissions
doas chown -R www:www /var/www/htdocs/james-harney
doas chmod -R 755 /var/www/htdocs/james-harney
```

## Step 3: Configure httpd

```sh
# Copy the server configuration
doas cp /var/www/htdocs/james-harney/server/httpd.conf /etc/httpd.conf

# Edit if needed (update domain name)
doas vi /etc/httpd.conf
```

## Step 4: Start Web Services

```sh
# Enable services to start on boot
doas rcctl enable httpd php_fpm

# Start services now
doas rcctl start php_fpm
doas rcctl start httpd

# Verify they're running
doas rcctl check httpd
doas rcctl check php_fpm
```

## Step 5: Configure Firewall (if needed)

```sh
# Edit firewall rules
doas vi /etc/pf.conf
```

Add this line:
```
pass in on egress proto tcp to port { 80 443 } keep state
```

Reload firewall:
```sh
doas pfctl -f /etc/pf.conf
```

## Step 6: Test Your Website

Visit `http://YOUR-SERVER-IP` in your browser. You should see your website!

## Step 7: Point Your Domain

In your domain registrar's DNS settings:
- Add an A record pointing to your Vultr server IP
- Wait 5-15 minutes for DNS to propagate

---

## Updating Your Website

This is now super simple! Just pull the latest changes:

```sh
cd /var/www/htdocs/james-harney
doas git pull
doas rcctl restart httpd
```

Or use the deployment script:

```sh
cd /var/www/htdocs/james-harney
doas ./deploy.sh
```

---

## Troubleshooting

**Website not loading?**

1. Check if httpd is running:
   ```sh
   doas rcctl check httpd
   ```

2. Test the configuration:
   ```sh
   doas httpd -n
   ```

3. Check logs:
   ```sh
   doas tail /var/log/messages
   ```

4. Verify files exist:
   ```sh
   ls -la /var/www/htdocs/james-harney/
   ```

**PHP not working?**

1. Check PHP-FPM status:
   ```sh
   doas rcctl check php_fpm
   ```

2. Test PHP:
   ```sh
   echo "<?php phpinfo(); ?>" | doas tee /var/www/htdocs/james-harney/test.php
   ```
   Visit: `http://YOUR-SERVER-IP/test.php`

---

## Next Steps

- Set up HTTPS with Let's Encrypt (see DEPLOYMENT.md)
- Configure email sending for contact form (see DEPLOYMENT.md)
- Set up automated backups

**Need more detailed instructions?** See DEPLOYMENT.md for comprehensive documentation.
