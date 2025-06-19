###############################################################################################
### Layer 1 : Base image ######################################################################

FROM alpine:3.21.3


### Layer 2 : System tools & packages #########################################################
# (rarely changes, therefore mostly already cached)

RUN apk update && apk add --no-cache \
                                        curl \
                                        mariadb-client \
                                        php83 \
                                        php83-fpm


# # Install PHP and required extensions, along with other utilities

#                                         php83 \
#                                         php83-fpm \
#                                         php83-mysqli \
#                                         php83-json \
#                                         php83-curl \
#                                         php83-mbstring \
#                                         php83-xml \
#                                         php83-phar \
#                                         php83-session \
#                                         php83-gd \
#                                         php83-opcache \
#                                         php83-zlib \
#                                         php83-dom \
#                                         php83-fileinfo \
#                                         php83-tokenizer \
#                                         php83-ctype \
#                                         php83-iconv \
#                                         php83-openssl \
#                                         curl \
#                                         tar \
#                                         bash \
#                                         busybox-suid \
#                                         unzip \
#                                         mysql-client \
#                                         openrc
# # # Install PHP and required extensions, along with other utilities


### Layer 3 : Configuration and application files #############################################
# (changes more often)

# RUN mkdir -p /var/www/html

# COPY ./conf/nginx.conf /etc/nginx/
# # # Copy our NGINX configuration file

# COPY ./conf/php-fpm.conf /etc/php81/php-fpm.conf
# # # Copy our PHP-FPM configuration file

RUN mkdir /app
WORKDIR /app

COPY ./tools/entrypoint.sh .
RUN chmod +x ./entrypoint.sh
# # Copy our entrypoint script to handle startup tasks


# EXPOSE


### Layer 4 : Startup [script] ################################################################

ENTRYPOINT [ "./entrypoint.sh" ]
# CMD ["nginx", "-g", "daemon off;"] # now in .sh, ENTRYPOINT is better for custom scripts

