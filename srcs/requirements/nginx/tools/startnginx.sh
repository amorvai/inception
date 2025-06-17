#!/bin/sh

# start nginx in foreground (to keep container running)
# [-g] set global configuration directives
nginx -g 'daemon off;'