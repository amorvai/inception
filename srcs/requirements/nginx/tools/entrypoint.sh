#!/bin/sh

sh /usr/local/bin/generate_ssl.sh

### start nginx in foreground (to keep container running)
### [-g] set global configuration directives
# nginx -g 'daemon off;'

if [ "$1" = 'sh' ]; then
  exec "$1"
  # Run the interactive shell if 'sh' is the first argument,
  #  keeping the container in the foreground.
#   exec "$@"
else
  nginx -g 'daemon off;'
fi