#!/bin/sh

set -ex

# default: 120 sec
# https://github.com/torproject/tor/blob/tor-0.4.1.7/src/core/or/connection_edge.c#L1099
if [ -z "$SOCKS_TIMEOUT_SECONDS" ]; then
    sed -e '/{socks_timeout_seconds}/d' /torrc.template | tee /tmp/torrc
else
    sed -e "s/{socks_timeout_seconds}/$SOCKS_TIMEOUT_SECONDS/" /torrc.template | tee /tmp/torrc
fi

exec "$@"
