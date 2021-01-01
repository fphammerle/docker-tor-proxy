FROM alpine:3.12.3

ARG BIND_TOOLS_PACKAGE_VERSION=9.16.6-r0
ARG TOR_PACKAGE_VERSION=0.4.3.7-r0
RUN apk add --no-cache \
        bind-tools=$BIND_TOOLS_PACKAGE_VERSION `# dig` \
        tor=$TOR_PACKAGE_VERSION
VOLUME /var/lib/tor

#RUN apk add --no-cache \
#        less \
#        man-db \
#        tor-doc=$TOR_PACKAGE_VERSION
#ENV PAGER=less

EXPOSE 9050/tcp
EXPOSE 9053/udp
COPY torrc.template entrypoint.sh /
RUN chmod -c a+rX /torrc.template /entrypoint.sh
ENV SOCKS_TIMEOUT_SECONDS=
ENTRYPOINT ["/entrypoint.sh"]

USER tor
CMD ["tor", "-f", "/tmp/torrc"]

# keeping dns requests as network-liveness is too optimistic
# https://gitweb.torproject.org/torspec.git/tree/control-spec.txt
HEALTHCHECK CMD \
    printf "AUTHENTICATE\nGETINFO network-liveness\nQUIT\n" | nc localhost 9051 \
        | grep -q network-liveness=up \
    && dig -p 9053 +notcp +short google.com @localhost \
    || exit 1
