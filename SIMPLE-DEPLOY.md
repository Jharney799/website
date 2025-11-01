# Simple Git-Based Deployment

The website structure has been simplified! You can now clone and pull directly into your web directory.

## Initial Setup (One Time Only)

### On your OpenBSD server:

```sh
# 1. Install git
doas pkg_add git

# 2. Clone the repo directly into your web directory
doas git clone https://github.com/Jharney799/website.git /var/www/htdocs/james-harney

# 3. Set permissions
doas chown -R www:www /var/www/htdocs/james-harney
doas chmod -R 755 /var/www/htdocs/james-harney

# 4. Copy server config
doas cp /var/www/htdocs/james-harney/server/httpd.conf /etc/httpd.conf

# 5. Start services
doas rcctl enable httpd php_fpm
doas rcctl start php_fpm
doas rcctl start httpd
```

## Updating Your Website

### From your OpenBSD server (easiest):

```sh
# Pull latest changes
cd /var/www/htdocs/james-harney
doas git pull

# Restart services (if needed)
doas rcctl restart httpd
```

### Or use the deploy script:

```sh
cd /var/www/htdocs/james-harney
doas ./deploy.sh
```

## Directory Structure

```
/var/www/htdocs/james-harney/
├── index.html              # Your website files at root
├── about.html
├── style.css
├── fonts/
├── img/
├── server/                 # Server configs
│   ├── httpd.conf
│   └── httpd-ssl.conf
├── DEPLOYMENT.md           # Detailed docs
└── deploy.sh              # Auto-deploy script
```

## Benefits of New Structure

- ✅ No more nested `htdocs/` folder
- ✅ Just `git pull` to update
- ✅ Files are exactly where they need to be
- ✅ Cleaner, simpler workflow

## Troubleshooting

If you get permission errors:
```sh
doas chown -R www:www /var/www/htdocs/james-harney
```

If the site doesn't update:
```sh
doas rcctl restart httpd
```
