# 3proxy with mustached configuration
#

# #############################################################################
# Build stage
#

FROM alpine:3 AS builder

ENV VERSION=0.8.13

RUN apk add --update \
        alpine-sdk \
        linux-headers \
        wget \
        bash \
        unzip && \
    cd / && \
    wget -q  https://github.com/z3APA3A/3proxy/archive/${VERSION}.tar.gz && \
    tar -xf ${VERSION}.tar.gz && \
    cd 3proxy-${VERSION} && \
    make -f Makefile.Linux && \
    mkdir /build && \
    make -f Makefile.Linux prefix=/build install-bin

ADD https://github.com/quantumew/mustache-cli/releases/download/v1.0.0/mustache-cli-linux-amd64.zip \
  mustache-cli.zip

RUN unzip mustache-cli.zip -d /mustache-cli


# #############################################################################
# Application stage
#

FROM alpine:3

STOPSIGNAL SIGTERM
ENTRYPOINT ["/entrypoint"]

COPY --from=builder /build/bin/ /usr/local/bin/
COPY --from=builder /mustache-cli/mustache /usr/local/bin/
COPY entrypoint.sh /entrypoint
COPY config.mustache /etc/3proxy/config.mustache
COPY config.json /etc/3proxy/config.json
