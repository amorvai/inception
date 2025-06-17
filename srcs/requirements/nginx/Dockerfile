# Layer 1
FROM alpine:3.21.3

# Layer 2 (cached, rarely changes)
# # Install NGINX and OpenSSL
RUN apk update && apk add --no-cache \
                                        nginx \
                                        openssl

# Layer 3
# # Copy our NGINX configuration file  # (This is the file I am gonna edit a lot!)
COPY ./conf/nginx.conf /etc/nginx/


# Layer 4
# # sets global configuration directives
CMD ["nginx", "-g", "daemon off;"]

