#!/bin/sh

SSL_DIR="/etc/ssl/private"
KEY="$SSL_DIR/nginx.key"
CERT="$SSL_DIR/nginx.crt"

# set -x

if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
  mkdir -p "$SSL_DIR"
  # Create the directory if it does not exist

  echo "Generating self-signed SSL certificate ..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$KEY" \
    -out "$CERT" \
    -subj "/C=DE/ST=BW/L=Heilbronn/O=42/OU=42 Heilbronn/CN=amorvai.42.fr/UID=amorvai"
  chmod 600 "$KEY"
  chmod 644 "$CERT"
  # Set permissions for the key and certificate

  echo "SSL certificate generated successfully."
else
    echo "SSL certificate already exists."
fi