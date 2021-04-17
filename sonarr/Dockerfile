FROM alpine
ARG TZ
ARG USER
RUN apk upgrade --update && \
    apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add --no-cache ca-certificates libmediainfo sudo alpine-conf && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    setup-timezone -z ${TZ} && \
    apk del ca-certificates alpine-conf && \
    rm -rf /var/cache/apk/* && \
    adduser ${USER} -D && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers  && \
    wget "https://services.sonarr.tv/v1/download/main/latest?version=3&os=linux" -O sonarr.linux.tar.gz && \
    tar -xof sonarr.linux.tar.gz && \
    chown ${USER}:${USER} /Sonarr -R  && \    
    rm sonarr.linux.tar.gz
USER ${USER}
CMD ["/usr/bin/mono", "--debug", "/Sonarr/Sonarr.exe", "-nobrowser", "-data=/home/jeremy/.config/sonarr"]