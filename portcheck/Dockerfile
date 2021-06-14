# syntax=docker/dockerfile:1.2

FROM golang:alpine as build
ENV GOPROXY=direct
RUN apk add --no-cache git && \
    go get github.com/jerblack/server_tools/portcheck

FROM alpine
ARG TZ
ARG USER
COPY --from=build /go/bin/ /usr/bin/
RUN apk upgrade --update && \
    apk add --no-cache alpine-conf && \
    setup-timezone -z ${TZ} && \
    apk del alpine-conf && \
    rm -rf /var/cache/apk/* && \
    adduser ${USER} -D
USER ${USER}
CMD ["portcheck"]