FROM alpine
ARG TZ
ARG USER
RUN apk upgrade --update && \
    apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add --no-cache ca-certificates libmediainfo sudo alpine-conf libintl jq && \
    cert-sync /etc/ssl/certs/ca-certificates.crt && \
    setup-timezone -z ${TZ} && \
    apk del ca-certificates alpine-conf && \
    rm -rf /var/cache/apk/* && \
    adduser ${USER} -D && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers  && \
    wget "https://radarr.servarr.com/v1/update/master/updatefile?os=linuxmusl&runtime=netcore&arch=x64" -O radarr.linux.tar.gz && \
    tar -xof radarr.linux.tar.gz && \
    chown ${USER}:${USER} /Radarr -R  && \    
    rm radarr.linux.tar.gz && \
    cd /Radarr && \
    cat Radarr.runtimeconfig.json | jq '.runtimeOptions.configProperties."System.Globalization.Invariant" = true' > tmp.json && \
    mv tmp.json Radarr.runtimeconfig.json

USER ${USER}
CMD ["/Radarr/Radarr", "-nobrowser", "-data=/home/jeremy/.config/radarr"]
