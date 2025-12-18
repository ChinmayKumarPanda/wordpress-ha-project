#!/bin/bash
set -e

# ---------------- SYSTEM SETUP ----------------
dnf update -y
dnf install -y httpd php php-mysqlnd php-gd php-json php-mbstring php-xml php-curl wget unzip aws-cli

systemctl enable httpd
systemctl start httpd

cat <<EOF > /etc/httpd/conf.d/wordpress.conf
<Directory "/var/www/html">
    AllowOverride All
    Require all granted
</Directory>
EOF

# ---------------- WORDPRESS SETUP ----------------
rm -rf /var/www/html/*
mkdir -p /var/www/html
cd /var/www/html

wget https://wordpress.org/latest.zip
unzip latest.zip
mv wordpress/* .
rm -rf wordpress latest.zip

# ---------------- CREATE wp-config.php (CRITICAL) ----------------
cat <<EOF > /var/www/html/wp-config.php
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'admin');
define('DB_PASSWORD', 'StrongPassword123!');
define('DB_HOST', 'wp-db.cjsseyqs8ndx.ap-south-1.rds.amazonaws.com');

define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

/* CloudFront CDN */
define('WP_CONTENT_URL', 'https://d2uivq2tvi2zd2.cloudfront.net/wp-content');

\$table_prefix = 'wp_';
define('WP_DEBUG', false);

if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

require_once ABSPATH . 'wp-settings.php';
EOF

# ---------------- PERMISSIONS ----------------
chown -R apache:apache /var/www/html
chmod 640 /var/www/html/wp-config.php
chmod -R 755 /var/www/html

setenforce 0 || true

# ---------------- S3 MEDIA SYNC ----------------
mkdir -p /var/www/html/wp-content/uploads
chown -R apache:apache /var/www/html/wp-content

aws s3 sync s3://wp-media-prod-bucket/wp-content/uploads/ \
/var/www/html/wp-content/uploads/

cat <<EOF > /etc/cron.d/wp-s3-sync
*/5 * * * * root aws s3 sync /var/www/html/wp-content/uploads s3://wp-media-prod-bucket/wp-content/uploads/ >> /var/log/wp-s3-sync.log 2>&1
EOF

chmod 644 /etc/cron.d/wp-s3-sync

systemctl restart crond
systemctl restart httpd
