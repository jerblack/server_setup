FROM golang:alpine as build
ENV GOPROXY=direct
RUN apk add --no-cache git && \
    go get github.com/jerblack/server_tools/dnsup && \
    go get github.com/jerblack/server_tools/connected

FROM alpine
ARG TZ
COPY --from=build /go/bin/ /usr/bin/
RUN apk upgrade --update && \
    apk add wireguard-tools ca-certificates tcptraceroute bind-tools alpine-conf && \
    setup-timezone -z ${TZ} && \
    apk del alpine-conf && \
    rm -rf /var/cache/apk/* && \
    echo net.ipv6.conf.all.disable_ipv6 = 1 >> /etc/sysctl.conf
CMD ["connected"]

# docker build --rm --no-cache -t vpn .
# docker run -d --name=vpn --privileged --cap-add=NET_ADMIN --net=bridge -it --rm vpn sh
# docker run --name=vpn -it --rm vpn bash
# docker exec -it vpn sh

