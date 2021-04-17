# syntax=docker/dockerfile:1.2
FROM secrets

FROM golang:alpine as dnsup
COPY --from=secrets dnsup.conf .
ENV CGO_ENABLED=0
RUN apk add --no-cache subversion && \
    svn export https://github.com/jerblack/server_tools/trunk/dnsup && \
    mv dnsup.conf dnsup/ && cd dnsup && \
    go build -ldflags="-s -w"

FROM golang:alpine as connected
COPY --from=secrets wg ./wg
COPY --from=secrets connected.conf .
ENV CGO_ENABLED=0
RUN apk add --no-cache subversion && \
    svn export https://github.com/jerblack/server_tools/trunk/connected && \
    mv wg connected/ && mv connected.conf connected/ && cd connected && \
    go build -ldflags="-s -w"


FROM alpine
ARG TZ
COPY --from=dnsup /go/dnsup/dnsup /usr/bin/dnsup
COPY --from=connected /go/connected/connected /usr/bin/connected
RUN apk upgrade --update && \
    apk add wireguard-tools ca-certificates tcptraceroute bind-tools alpine-conf && \
    setup-timezone -z ${TZ} && \
    apk del alpine-conf && \
    rm -rf /var/cache/apk/*
CMD ["connected"]

# docker build --rm --no-cache -t vpn .
# docker run -d --name=vpn --privileged --cap-add=NET_ADMIN --net=bridge -it --rm vpn sh
# docker run --name=vpn -it --rm vpn bash
# docker exec -it vpn sh

