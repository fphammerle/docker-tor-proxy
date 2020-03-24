FROM alpine:3.11

ARG CURL_PACKAGE_VERSION=7.67.0-r0
ARG BIND_TOOLS_PACKAGE_VERSION=9.14.8-r5
ARG TOR_PACKAGE_VERSION=0.4.1.9-r0
RUN adduser -S onion \
    && apk add --no-cache \
        curl=$CURL_PACKAGE_VERSION \
        bind-tools=$BIND_TOOLS_PACKAGE_VERSION `# dig` \
        tor=$TOR_PACKAGE_VERSION

# RUN apk add --no-cache \
#         less \
#         man \
#         tor-doc=$TOR_PACKAGE_VERSION
# ENV PAGER=less

EXPOSE 9050/tcp
EXPOSE 9053/udp
COPY torrc.template entrypoint.sh /
ENV SOCKS_TIMEOUT_SECONDS=
ENTRYPOINT ["/entrypoint.sh"]
RUN chmod -c a+rX /torrc.template /entrypoint.sh

USER onion
CMD ["tor", "-f", "/tmp/torrc"]

HEALTHCHECK CMD \
    curl --silent --socks5 localhost:9050 https://google.com > /dev/null \
    && [ ! -z "$(dig -p 9053 +notcp +short one.one.one.one @localhost)" ] \
    || exit 1
