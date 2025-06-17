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

# not needed for alpine:
        # RUN mkdir -p /usr/local/bin 
        # RUN mkdir -p /run/nginx

COPY ./conf/nginx.conf /etc/nginx/
# # Copy our NGINX configuration file

COPY tools/generate_ssl.sh /usr/local/bin/generate_ssl.sh
RUN chmod +x /usr/local/bin/generate_ssl.sh
# # Copy our SSL generation script

        # RUN /usr/local/bin/generate_ssl.sh
        # # we could run this script here, but really it should be run in the entrypoint script
        # # because if run here the same certificate would used for different containers

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
# # Copy our entrypoint script to handle startup tasks


### Layer 4 : Startup [script] ################################

ENTRYPOINT [ "sh", "/usr/local/bin/entrypoint.sh" ]
# CMD ["nginx", "-g", "daemon off;"] # old way, but ENTRYPOINT is better for custom scripts
