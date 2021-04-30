#!/bin/sh

set -e

if [ "$(id -u)" -eq 0 ]; then
    nft add rule ip nat PREROUTING ip protocol tcp fib daddr type != local counter redirect to :9040 \
        || echo 'failed to configure nftables for transparent proxy (missing CAP_NET_ADMIN?)'
    exec su -s /bin/sh tor -- "$0" "$@"
fi

# default: 120 sec
# https://github.com/torproject/tor/blob/tor-0.4.1.7/src/core/or/connection_edge.c#L1099
if [ -z "$SOCKS_TIMEOUT_SECONDS" ]; then
    sed -e '/{socks_timeout_seconds}/d' /torrc.template > /tmp/torrc
else
    sed -e "s/{socks_timeout_seconds}/$SOCKS_TIMEOUT_SECONDS/" /torrc.template > /tmp/torrc
fi

exec "$@"
