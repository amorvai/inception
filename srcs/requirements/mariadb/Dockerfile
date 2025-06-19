###############################################################################################
### Layer 1 : Base image ######################################################################

FROM alpine:3.21.3


### Layer 2 : System tools & packages #########################################################
# (rarely changes, therefore mostly already cached)

RUN apk update && apk add --no-cache \
                                        mariadb \
                                        mariadb-client
# Install MariaDB and its client


# ### Layer 3 : Configuration and application files #############################################
# # (changes more often)


# COPY ./conf/mariadb.conf /etc/my.cnf
# RUN chmod 644 /etc/my.cnf                     # revise with /etc/my.cnf.d/mariadb-server.cnf

COPY ./conf/mariadb.conf /etc/my.cnf.d/mariadb-server.cnf
# This file gets loaded automatically as part of the !includedir /etc/my.cnf.d directive, which is usually present in /etc/my.cnf
RUN chmod 644 /etc/my.cnf.d/mariadb-server.cnf


# RUN     mkdir -p /run/mysqld /var/lib/mysql /etc/mysql \
# &&      chown -R mysql:mysql /run/mysqld /var/lib/mysql       # handled in entrypoint.sh bc here it's 
                                                                        # during build-time only: if you mount volumes at runtime (like /var/lib/mysql or /run/mysqld),
                                                                        #  permissions might get reset or mismatch, because mounted volumes override the image directories.
                                                                        # less flexible: changes to volume mounts or runtime environment might require rebuilding the image.

COPY ./tools/entrypoint.sh /usr/local/bin/mariadb-entrypoint.sh
RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

EXPOSE 3306


### Layer 4 : Startup [script] ################################################################

ENTRYPOINT [ "sh", "./usr/local/bin/mariadb-entrypoint.sh" ]

