# Quick Start - Get Your Website Online in 5 Minutes

This guide assumes you have a fresh OpenBSD VPS on Vultr.

## Step 1: Prepare Your Server (SSH into your Vultr VPS)

```sh
# Install PHP
doas pkg_add php php-fpm

# Create the httpd configuration file
doas vi /etc/httpd.conf
```

Paste this configuration (replace `YOUR-DOMAIN.com` with your actual domain):

```
server "YOUR-DOMAIN.com" {
    alias "www.YOUR-DOMAIN.com"
    listen on * port 80
    root "/htdocs/james-harney"
    directory index index.html

    location "*.php" {
        fastcgi socket "/run/php-fpm.sock"
    }
}

types {
    include "/usr/share/misc/mime.types"
}
```

## Step 2: Create Web Directory

```sh
doas mkdir -p /var/www/htdocs/james-harney
```

## Step 3: Upload Your Website Files

**Option A: Using SCP (from your local machine)**

Download this repository to your local machine, then:

```sh
cd website
# Edit deploy-scp.sh and set your server IP and username
vi deploy-scp.sh
# Run deployment
./deploy-scp.sh
```

**Option B: Manual SFTP Upload**

1. Use FileZilla, Cyberduck, or WinSCP
2. Connect to your server
3. Upload all files from `htdocs/` to `/var/www/htdocs/james-harney/`
4. Then SSH to server and run:
   ```sh
   doas chown -R www:www /var/www/htdocs/james-harney
   doas chmod -R 755 /var/www/htdocs/james-harney
   ```

**Option C: Using wget (if files are hosted somewhere)**

```sh
cd /tmp
# Download and extract your website files
# Then:
doas cp -r /tmp/your-extracted-files/* /var/www/htdocs/james-harney/
doas chown -R www:www /var/www/htdocs/james-harney
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

## Next Steps

- Set up HTTPS with Let's Encrypt (see DEPLOYMENT.md)
- Configure email sending for contact form (see DEPLOYMENT.md)
- Set up automated backups

---

**Need more detailed instructions?** See DEPLOYMENT.md for comprehensive documentation.
