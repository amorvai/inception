#!/bin/sh

# set -x
set -e

if [ "$1" = 'sh' ]; then
  exec "$1"
  # Run the interactive shell if 'sh' is the first argument,
  #  keeping the container in the foreground.
#   exec "$@"
else
  nginx -g 'daemon off;'
fi
