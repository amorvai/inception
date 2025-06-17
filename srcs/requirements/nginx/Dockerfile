### Layer 1 : Base image ######################################

FROM alpine:3.21.3
# Use a minimal Alpine image for a smaller footprint


### Layer 2 : System tools & packages #########################
# (rarely changes, therefore mostly already cached)

RUN apk update && apk add --no-cache \
                                        nginx \
                                        openssl
# # Install NGINX and OpenSSL


### Layer 3 : Configuration and application files #############
# (changes more often)

COPY ./conf/nginx.conf /etc/nginx/
# # Copy our NGINX configuration file

# not needed for alpine:
        # RUN mkdir -p /usr/local/bin 
        # RUN mkdir -p /run/nginx

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh


# Layer 4
ENTRYPOINT [ "sh", "/usr/local/bin/entrypoint.sh" ]
# CMD ["nginx", "-g", "daemon off;"] # old way, but ENTRYPOINT is better for custom scripts
