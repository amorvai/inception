#!/bin/sh

# set -x
set -ue

# Check if working directory exists, if not create it
if [ ! -d /var/www/html ]; then
    echo "Creating WordPress working directory..."
    mkdir -p /var/www/html
fi

# move to the WordPress Working directory
# cd /var/www/html                              #WORKING_DIRECTORY set in Dockerfile

# Check if group 'www-data' exists, if not create it
if ! getent group www-data > /dev/null 2>&1; then
  echo "Creating 'www-data' group..."
  addgroup -S www-data
fi

# Check if user 'www-data' exists, if not create it and assign to group
if ! getent passwd www-data > /dev/null 2>&1; then
  echo "Creating 'www-data' user..."
  adduser -S -G www-data -h /usr/sbin/nologin www-data
fi

# Try connecting to MariaDB server
max_attempts=10
count=0
echo "Waiting for MariaDB to be available..."
until mariadb-admin ping --host=mariadb --protocol=tcp --silent --connect-timeout=2; do
  count=$((count + 1))
  if [ $count -ge $max_attempts ]; then
    echo "MariaDB not available after $max_attempts attempts, exiting."
    exit 1
  fi
  echo "Waiting for MariaDB to be available... ($count/$max_attempts)"
  sleep 3
done
echo "MariaDB is ready."

# Check if WordPress is already installed by looking for wp-config.php
if [ ! -f wp-config.php ]; then
    echo "Installing WordPress..."

    # Download WordPress core
    wp core download --allow-root --path=/var/www/html

    # Create wp-config.php
    wp config create \
        --dbname="$MYSQL_DB_NAME" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_USER_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --allow-root \
        # --path=/var/www/html                  # not needed, we moved into /var/www/html (working directory)

    # Install WordPress
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="JustLeaveMeLonePls" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root \
        # --path=/var/www/html                  # not needed, we moved into /var/www/html (working directory)

    # Optionally add extra user
    if [ -n "$WP_GUEST_USER" ] && [ -n "$WP_GUEST_EMAIL" ]; then
        wp user create "$WP_GUEST_USER" "$WP_GUEST_EMAIL" \
            --role="${WP_GUEST_ROLE:-editor}" \
            --user_pass="$WP_GUEST_PASS" \
            --allow-root \
        #     --path=/var/www/html              # not needed, we moved into /var/www/html (working directory)
    fi

    # Set proper permissions on wp-content
    chmod -R o+w /var/www/html/wp-content
    echo "WordPress installation completed."
else
    echo "WordPress already installed."
fi

# Start PHP-FPM # exec: ensures the PHP-FPM service is as PID 1 , -F: running in the foreground
exec php-fpm83 -F