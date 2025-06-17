#!/bin/sh

### start nginx in foreground (to keep container running)
### [-g] set global configuration directives
# nginx -g 'daemon off;'

if [ "$1" = 'sh' ]; then
  exec "$@"
else
  nginx -g 'daemon off;'
fi