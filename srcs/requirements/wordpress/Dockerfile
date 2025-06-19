###############################################################################################
### Layer 1 : Base image ######################################################################

FROM alpine:3.21.3


### Layer 2 : System tools & packages #########################################################
# (rarely changes, therefore mostly already cached)

RUN apk update && apk add --no-cache \
                                        curl \
                                        mariadb-client \
                                        php83 \
                                        php83-fpm \
                                        php83-curl \
                                        php83-json \
                                        php83-mbstring \
                                        php83-mysqli \
                                        php83-phar \
                                        php83-session \
                                        php83-xml
# # Install PHP and required extensions, along with other utilities:
# System/Utility Packages:                              curl, mariadb-client;
# PHP Core & Process Manager:                           php83, php83-fpm;
# PHP Extensions: WordPress Dependencies:               php83-curl, php83-json, php83-mbstring,
#                                                       php83-mysqli, php83-phar, php83-session,
#                                                       php83-xml;


### Layer 3 : Configuration and application files #############################################
# (changes more often)


# RUN mkdir -p /var/www/html    # Creating runtime data dirs is better in entrypoint (in case volumes override them)
# WORKDIR /var/www/html         # moved this back to entrypoint.sh as well, because of the entrypoint script placement

# Get CLI tool (CLI client for WordPress management)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# COPY ./conf/www.conf /etc/conf.d/www.conf             #reevaluate this, whats right?
COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf
# Copy our WordPress configuration file

# COPY ./conf/php-fpm.conf /etc/php81/php-fpm.conf      #reevaluate this, whats right?
# # # Copy our PHP-FPM configuration file

# RUN mkdir /app                                        # PAtrick
# WORKDIR /app                                          #

# # Copy our entrypoint script to handle startup tasks

RUN sed -i '/^memory_limit\s*=/c\memory_limit = 512M' /etc/php83/php.ini \
    || echo "memory_limit = 512M" >> /etc/php83/php.ini
# RUN sed -i 's/^memory_limit = .*/memory_limit = 512M/' /etc/php83/php.ini \
# || echo "memory_limit = 512M" >> /etc/php83/php.ini
#                                                       # two ways: change (c\), replace (s///).
#                                                       # first is more tolerant towards whitespace.

EXPOSE 9000

COPY ./tools/entrypoint.sh .
RUN chmod +x ./entrypoint.sh

### Layer 4 : Startup [script] ################################################################

ENTRYPOINT [ "./entrypoint.sh" ]
# CMD ["nginx", "-g", "daemon off;"] # now in .sh, ENTRYPOINT is better for custom scripts

