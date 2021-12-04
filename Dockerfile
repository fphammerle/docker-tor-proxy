FROM docker.io/alpine:3.15.0

# nftables + dependencies add 2.3MB to image
ARG TOR_PACKAGE_VERSION=0.4.6.7-r1
ARG NFTABLES_PACKAGE_VERSION=1.0.1-r0
RUN apk add --no-cache \
        nftables=$NFTABLES_PACKAGE_VERSION \
        tor=$TOR_PACKAGE_VERSION
VOLUME /var/lib/tor

#RUN apk add --no-cache \
#        less \
#        man-db \
#        strace \
#        tor-doc=$TOR_PACKAGE_VERSION
#ENV PAGER=less

EXPOSE 9050/tcp
EXPOSE 9053/udp
COPY torrc.template entrypoint.sh /
RUN chmod -c a+rX /torrc.template /entrypoint.sh
ENV SOCKS_TIMEOUT_SECONDS= \
    EXIT_NODES= \
    EXCLUDE_EXIT_NODES=
ENTRYPOINT ["/entrypoint.sh"]

# entrypoint.sh drops privileges after configuring nftables for transparent proxy
#USER tor
CMD ["tor", "-f", "/tmp/torrc"]

# keeping dns requests as network-liveness is too optimistic
# https://gitweb.torproject.org/torspec.git/tree/control-spec.txt
HEALTHCHECK CMD \
    printf "AUTHENTICATE\nGETINFO network-liveness\nQUIT\n" | nc localhost 9051 \
        | grep -q network-liveness=up \
    && nslookup -port=9053 google.com localhost | grep -v NXDOMAIN | grep -q google \
    || exit 1

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION=
LABEL org.opencontainers.image.title="tor socks, dns & transparent proxy" \
    org.opencontainers.image.source="https://github.com/fphammerle/docker-tor-proxy" \
    org.opencontainers.image.revision="$REVISION"
