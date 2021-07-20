FROM golang:1.16-alpine as build
ENV GOPROXY=direct
RUN apk add --no-cache git && \
    go get github.com/jerblack/server_tools/castctl

FROM alpine
ARG TZ
ARG USER
COPY --from=build /go/bin/ /usr/bin/
RUN apk upgrade --update && \
    apk add --no-cache alpine-conf libcap && \
    setup-timezone -z ${TZ} && \
    apk del alpine-conf && \
    rm -rf /var/cache/apk/* && \
    adduser ${USER} -D && \
    setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/castctl 
USER ${USER}
CMD ["castctl"]