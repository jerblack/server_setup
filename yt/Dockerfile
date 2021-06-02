# syntax=docker/dockerfile:1.2

FROM golang:alpine as build
ENV GOPROXY=direct
RUN apk add --no-cache git curl jq alpine-sdk unzip && \
    go get github.com/jerblack/server_tools/yt && \
    YTDL=$(curl -s https://api.github.com/repos/ytdl-org/youtube-dl/releases/latest | jq -r '.assets[] | select(.name=="youtube-dl").browser_download_url') && \
    curl -Lo bin/youtube-dl $YTDL && \
    chmod +x bin/youtube-dl && \
    RCLONE=$(curl -s https://api.github.com/repos/rclone/rclone/releases/latest | jq -r '.assets[].browser_download_url|select(endswith("-linux-amd64.zip"))') && \
    curl -Lo rclone.zip $RCLONE && \
    unzip -j rclone.zip -d rclone && \
    mv rclone/rclone bin/

FROM alpine
ARG TZ
ARG USER
COPY --from=build /go/bin /usr/local/bin 
RUN apk upgrade --update && \
    apk add --update --no-cache alpine-conf curl ffmpeg python3 && \
    ln -sf python3 /usr/bin/python && \
    setup-timezone -z ${TZ} && \
    adduser -D ${USER} && \
    apk del alpine-conf
USER ${USER}
CMD ["yt"]