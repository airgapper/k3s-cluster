FROM alpine:latest as builder
RUN apk add --no-cache --update wireguard-tools iproute2 iptables tcpdump vim
COPY if-down-wg0 /tmp/
COPY if-up-wg0 /tmp/
