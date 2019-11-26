#!/bin/sh
set -e

/usr/local/bin/mustache \
    /etc/3proxy/config.json \
    /etc/3proxy/config.mustache \
  > /etc/3proxy/config
exec /usr/local/bin/3proxy /etc/3proxy/config
