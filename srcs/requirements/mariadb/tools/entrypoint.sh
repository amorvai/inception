#!/bin/sh

# entrypoint.sh for MariaDB container

# set -x
# -x : Print commands and their arguments as they are executed.
set -eu
# -e : Exit immediately if a command exits with a non-zero status.
# -u : Treat unset variables as an error when substituting.

# Check for required environment variables
: "${MYSQL_ROOT_PASSWORD:?Missing required MYSQL_ROOT_PASSWORD}"
: "${MYSQL_DB_NAME:?Missing required MYSQL_DB_NAME}"
: "${MYSQL_USER:?Missing required MYSQL_USER}"
: "${MYSQL_USER_PASSWORD:?Missing required MYSQL_USER_PASSWORD}"


# Ensure 'mysql' group exists
if ! getent group mysql > /dev/null 2>&1; then
    echo "Creating mysql group..."
    addgroup -S mysql
fi
# Ensure 'mysql' user exists
if ! getent passwd mysql > /dev/null 2>&1; then
    echo "Creating mysql user..."
    adduser -S -G mysql -h /var/lib/mysql mysql
fi
# -S / --system : Create a system user (no home directory, no password).
# -G / --: Add the user to the specified group (in this case, 'mysql').
# -h : Specify the home directory for the user (in this case, '/var/lib/mysql').

# Ensure the runtime directories exist and are owned by MySQL
mkdir -p /run/mysqld /var/lib/mysql /var/log/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql /var/log/mysql
chmod 755 -R /run/mysqld /var/lib/mysql /var/log/mysql
# -p : Create the directory if it does not exist.
# -R : Recursively change ownership and permissions for all files and directories under the specified path


# Initialize the MariaDB data directory if not already initialized
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initialize MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null # --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
    echo "MariaDB data directory initialized."
fi

# Initialize the wordpress database if it does not exist
if [ ! -d /var/lib/mysql/wordpress ]; then
    echo "Initializing WordPress database..."

    # Create initial database and user using a temporary SQL file
    TEMP_SQL_FILE=$(mktemp)
    if [ ! -f "$TEMP_SQL_FILE" ]; then
        echo "Error: Failed to create temp file (for wordpress database set up)."
        return 1
    fi

    cat > "$TEMP_SQL_FILE" <<-EOF
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM mysql.user WHERE user='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB_NAME}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DB_NAME}\`.* TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

    # Bootstrap the database with the user/database setup
    # --bootstrap runs the server in a special mode to execute SQL commands from stdin
    # --user=mysql ensures the commands are run with the mysql user
    /usr/bin/mariadbd --bootstrap --user=mysql < "$TEMP_SQL_FILE"
    rm -f "$TEMP_SQL_FILE"

    echo "WordPress database initialized."
fi


# Start MariaDB server as the 'mysql' user
# This assumes the container is run with the correct user context
# as that user has the necessary permissions to access the data directory.
# as that user has been bootstrapped with the necessary permissions.
exec /usr/bin/mariadbd --user=mysql

# # Start MariaDB server as root (assumes proper security context)
# exec /usr/bin/mariadbd -u root 



#############################################  Uebersichtlich ohne commentary -- DASSELBE NICHT WEG BITTE

# set -eu
# # Check for required environment variables
# : "${MYSQL_ROOT_PASSWORD:?Missing required MYSQL_ROOT_PASSWORD}"
# : "${MYSQL_DATABASE:?Missing required MYSQL_DATABASE}"
# : "${MYSQL_USER:?Missing required MYSQL_USER}"
# : "${MYSQL_PASSWORD:?Missing required MYSQL_PASSWORD}"
# # Ensure 'mysql' group exists
# if ! getent group mysql > /dev/null; then
#     echo "Creating mysql group..."
#     addgroup -S mysql
# fi
# # Ensure 'mysql' user exists
# if ! getent passwd mysql > /dev/null; then
#     echo "Creating mysql user..."
#     adduser -S -G mysql -h /var/lib/mysql mysql
# fi
# # Ensure the runtime directories exist and are owned by MySQL
# mkdir -p /run/mysqld /var/lib/mysql
# chown -R mysql:mysql /run/mysqld /var/lib/mysql
# # Initialize the MariaDB data directory if not already initialized
# if [ ! -d /var/lib/mysql/mysql ]; then
#     echo "Initialize MariaDB data directory..."
#     mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null # --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
# fi

# Initialize the wordpress database if it does not exist
# if [ ! -d /var/lib/mysql/wordpress ]; then
#     # Create initial database and user using a temporary SQL file
#     TEMP_SQL_FILE=$(mktemp)
#     if [ ! -f "$TEMP_SQL_FILE" ]; then
#         echo "Error: Failed to create temp file (for wordpress database set up)."
#         exit 1
#     fi
#     cat > "$TEMP_SQL_FILE" <<-EOF
# USE mysql;
# FLUSH PRIVILEGES;
# DELETE FROM mysql.user WHERE user='';
# DROP DATABASE IF EXISTS test;
# DELETE FROM mysql.db WHERE Db='test';
# DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
# FLUSH PRIVILEGES;
# EOF
#     /usr/bin/mariadbd --bootstrap --user=mysql < "$TEMP_SQL_FILE"
#     rm -f "$TEMP_SQL_FILE"
# fi

# exec /usr/bin/mariadbd --user=mysql