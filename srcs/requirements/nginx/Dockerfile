###############################################################################################
### Layer 1 : Base image ######################################################################

FROM alpine:3.21.3
# Use a minimal Alpine image for a smaller footprint



### Layer 2 : System tools & packages #########################################################
# (rarely changes, therefore mostly already cached)

RUN apk update && apk add --no-cache \
                                        nginx \
                                        openssl
# # Install NGINX and OpenSSL



### Layer 3 : Configuration and application files #############################################
# (changes more often)

RUN mkdir -p /var/www/html
COPY tools/test.html /var/www/html/index.html

# not needed for alpine:
        # RUN mkdir -p /usr/local/bin 
        # RUN mkdir -p /run/nginx

COPY ./conf/nginx.conf /etc/nginx/
# # Copy our NGINX configuration file

COPY tools/generate_ssl.sh /usr/local/bin/generate_ssl.sh
RUN chmod +x /usr/local/bin/generate_ssl.sh
# # Copy our SSL generation script

        # RUN /usr/local/bin/generate_ssl.sh
        # # we could run this script here, but really it should run in the entrypoint script
        # # because if run here, the same certificate would used for different containers

COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
# # Copy our entrypoint script to handle startup tasks


EXPOSE 443


### Layer 4 : Startup [script] ################################################################

ENTRYPOINT [ "sh", "/usr/local/bin/entrypoint.sh" ]
# CMD ["nginx", "-g", "daemon off;"] # now in .sh, ENTRYPOINT is better for custom scripts



###############################################################################################################################
# How to build and run the container with NGINX: ##############################################################################


# docker build [OPTIONS] PATH | URL | -
###############################################################################################################################
#
# [OPTIONS]:
#       # --help        [ docker build --help ] : show help message with all options
#
#       # -t [image_name]                       : give own image name                           (--tag)
#       # --no-cache                            : build without cache (useful for debugging)
#       # --progress=plain                      : show build progress in plain text (useful for debugging)
#       # --quiet                               : suppress build output (useful for production)
#
# Example:
# "docker build -t nginx_image ."
#                               '.' is PATH and refers to the current directory where the Dockerfile is located.
#
# Mine:
# docker build -t testXX_nginx .
# docker build -t testXX_nginx ./srcs/requirements/nginx
# docker build -t testXX_nginx --no-cache .
# docker build -t testXX_nginx --progress=plain .
# docker build -t testXX_nginx --no-cache --progress=plain .


# docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
###############################################################################################################################
#
# [OPTIONS]:
#       # --help          [ docker run --help ] : show help message with all options
#
#       # -d                                    : run in detached mode                          (--detach)
#       # -i                                    : run in interactive mode                       (--interactive)
#       # -t                                    : allocate a pseudo-TTY (a virtual terminal)    (--tty)
#               # -it                                   : run in interactive mode with a TTY
#       # -p [host_port]:[container_port]       : map ports                                     (--publish list)
#       # -v [host_path]:[container_path]       : mount a volume                                (--volume list)
#       # --name [container_name]               : give own container name
#       # --rm                                  : remove container after stopping it
#       # --network [network_name]              : connect to a specific network
#
# Example:
# "docker run -d -p 443:443 --name nginx_container100 nginx_image"
#                                                       'nginx_image' is the name of the image we built before.
#
# Mine:
# docker run -d -p 443:443 testXX_nginx
# docker run -d -p 443:443 --name test_runXX testXX_nginx
# docker run -d -p 443:443 -rm testXX_nginx
# docker run -it -p 443:443 testXX_nginx sh
# docker run -it -p 443:443 -rm testXX_nginx sh

