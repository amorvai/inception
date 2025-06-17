#!/bin/sh

SSL_DIR="/etc/ssl/private"
KEY="$SSL_DIR/nginx.key"
CERT="$SSL_DIR/nginx.crt"

# set -x

if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
  echo "Generating self-signed SSL certificate..."
  mkdir -p "$SSL_DIR"
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$KEY" \
    -out "$CERT" \
    -subj "/C=DE/ST=BW/L=Heilbronn/O=42/OU=42 Heilbronn/CN=amorvai.42.fr/UID=amorvai"
else
  echo "SSL certificate already exists."
fi