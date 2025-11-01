# James Harney's Personal Website

A self-hosted personal website built with simple HTML, CSS, and PHP.

## Features

- Clean, minimalist design with dark theme
- Monospace font (Anonymous Pro)
- PHP contact form
- Last updated timestamps on all pages
- Mobile responsive (work in progress)

## Quick Deploy to OpenBSD

```sh
# On your server
doas pkg_add git php php-fpm
doas git clone https://github.com/Jharney799/website.git /var/www/htdocs/james-harney
doas cp /var/www/htdocs/james-harney/server/httpd.conf /etc/httpd.conf
doas chown -R www:www /var/www/htdocs/james-harney
doas rcctl enable httpd php_fpm
doas rcctl start php_fpm httpd
```

## Updating

```sh
cd /var/www/htdocs/james-harney
doas git pull
doas rcctl restart httpd
```

## Documentation

- **SIMPLE-DEPLOY.md** - Quick git-based deployment guide
- **QUICKSTART.md** - 5-minute setup guide
- **DEPLOYMENT.md** - Comprehensive deployment documentation

## Directory Structure

```
.
├── index.html          # Homepage
├── about.html         # About page
├── now.html           # Now page
├── contact.html       # Contact form
├── art.html           # Art gallery
├── projects.html      # Projects showcase
├── masters.html       # The Masters
├── loginomicon.html   # The Loginomicon
├── style.css          # Main stylesheet
├── process_form.php   # Contact form handler
├── fonts/             # Web fonts
├── img/               # Images
└── server/            # Server configuration files
    ├── httpd.conf     # HTTP configuration
    └── httpd-ssl.conf # HTTPS configuration
```

## License

Personal project - all content © James Harney

## Tech Stack

- HTML5
- CSS3
- PHP
- OpenBSD httpd
- Anonymous Pro font
