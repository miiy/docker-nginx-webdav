#!/bin/bash
set -e

# first arg is `-foo` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- nginx "$@"
fi

exec "$@"
