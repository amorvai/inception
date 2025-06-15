# Layer 1
FROM debian:bullseye

# Layer 2 (cached, rarely changes)
# # Install NGINX and OpenSSL
RUN apt-get update && apt-get install -y nginx openssl

# Layer 3
# # Copy our NGINX configuration file  # (This is the file I am gonna edit a lot!)
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Layer 4
CMD ["nginx", "-g", "daemon off;"]

