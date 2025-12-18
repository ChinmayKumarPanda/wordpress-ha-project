#!/bin/bash
set -e

# Update system
dnf update -y

# Install Apache, PHP & required extensions
dnf install -y httpd php php-mysqlnd php-gd php-json php-mbstring php-xml php-curl wget unzip

# Enable Apache
systemctl enable httpd

# Allow .htaccess for WordPress
cat <<EOF > /etc/httpd/conf.d/wordpress.conf
<Directory "/var/www/html">
    AllowOverride All
    Require all granted
</Directory>
EOF

# Clean old WordPress files (CRITICAL for ASG)
rm -rf /var/www/html/*
mkdir -p /var/www/html
cd /var/www/html

# Download and install WordPress
wget https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress/* .
rm -rf wordpress latest.zip

# PERMANENTLY remove wp-config.php
rm -f /var/www/html/wp-config.php

# Permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# Disable SELinux enforcement (safe for demo/project)
setenforce 0 || true

# Start Apache
systemctl restart httpd
