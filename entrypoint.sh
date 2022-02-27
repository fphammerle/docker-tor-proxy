#!/bin/sh

set -e

if [ "$(id -u)" -eq 0 ]; then
    nft add chain ip nat PREROUTING { type nat hook prerouting priority dstnat \; } || true
    nft add rule ip nat PREROUTING ip protocol tcp fib daddr type != local counter redirect to :9040 \
        || echo 'warning: failed to configure nftables for transparent proxy (missing CAP_NET_ADMIN?)'
    nft add rule ip nat PREROUTING fib daddr type local udp dport 53 counter redirect to :9053 \
        || echo 'warning: failed to configure nftables for DNS proxy' \
                '(alternative for less flexible `docker run --publish 53:9053 ...`)'
    exec su -s /bin/sh tor -- "$0" "$@"
fi

# default: 120 sec
# https://github.com/torproject/tor/blob/tor-0.4.1.7/src/core/or/connection_edge.c#L1099
if [ -z "$SOCKS_TIMEOUT_SECONDS" ]; then
    sed -e '/{socks_timeout_seconds}/d' /torrc.template > /tmp/torrc
else
    sed -e "s/{socks_timeout_seconds}/$SOCKS_TIMEOUT_SECONDS/" /torrc.template > /tmp/torrc
fi

# > list of identity fingerprints, country codes, and address patterns
if [ ! -z "$EXIT_NODES" ]; then
    echo -n 'ExitNodes ' >> /tmp/torrc
    printenv EXIT_NODES >> /tmp/torrc
fi
if [ ! -z "$EXCLUDE_EXIT_NODES" ]; then
    echo -n 'ExcludeExitNodes ' >> /tmp/torrc
    printenv EXCLUDE_EXIT_NODES >> /tmp/torrc
fi

exec "$@"
