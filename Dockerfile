FROM alpine:3.12

ARG CURL_PACKAGE_VERSION=7.69.1-r1
ARG BIND_TOOLS_PACKAGE_VERSION=9.16.6-r0
ARG TOR_PACKAGE_VERSION=0.4.3.5-r0
RUN apk add --no-cache \
        curl=$CURL_PACKAGE_VERSION \
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

HEALTHCHECK CMD \
    curl --silent --socks5 localhost:9050 https://google.com > /dev/null \
    && [ ! -z "$(dig -p 9053 +notcp +short one.one.one.one @localhost)" ] \
    || exit 1
