# syntax=docker/dockerfile:1.2

FROM secrets

FROM golang:alpine as mux
ENV CGO_ENABLED=0
RUN apk add --no-cache subversion && \
    svn export https://github.com/jerblack/server_tools/trunk/mux && \
    cd mux && go build -ldflags="-s -w"

FROM golang:alpine as extract
ENV CGO_ENABLED=0
RUN apk add --no-cache subversion && \
    svn export https://github.com/jerblack/server_tools/trunk/extract && \
    cd extract && go build -ldflags="-s -w"

FROM golang:alpine as hydra
COPY --from=secrets hydra.conf .
ENV CGO_ENABLED=0
RUN go get github.com/gdm85/go-libdeluge && \
    go get golang.org/x/sys/unix && \
    apk add --no-cache subversion && \
    svn export https://github.com/jerblack/server_tools/trunk/hydra && \
    mv hydra.conf hydra/ && cd hydra && go build -ldflags="-s -w"

FROM alpine
ARG TZ
ARG USER
COPY --from=mux /go/mux/mux /usr/bin/mux
COPY --from=extract /go/extract/extract /usr/bin/extract
COPY --from=hydra /go/hydra/hydra /usr/bin/hydra
RUN apk upgrade --update && \
    apk add --no-cache unrar unzip sudo ffmpeg mkvtoolnix file alpine-conf && \
    setup-timezone -z ${TZ} && \
    apk del alpine-conf && \
    rm -rf /var/cache/apk/* && \
    adduser ${USER} -D && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER ${USER}
CMD ["hydra"]