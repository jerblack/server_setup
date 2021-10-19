FROM alpine AS par
ENV CFLAGS="-O3 -pipe -fstack-protector-strong"
ENV CXXFLAGS="-O3 -pipe -fstack-protector-strong"
ENV LDFLAGS="-static"
RUN apk add --update libffi-dev libressl-dev git automake make bash autoconf alpine-sdk && \
    git clone https://github.com/Parchive/par2cmdline.git  && \
    cd par2cmdline && \
    ./automake.sh && \
    ./configure && \
    make

FROM golang:alpine as build
ENV GOPROXY=direct
RUN apk add --no-cache git && \
    go install github.com/jerblack/server_tools/mux@latest && \
    go install github.com/jerblack/server_tools/extract@latest 
    
FROM alpine
ARG TZ
ARG USER
WORKDIR /config/
COPY --from=build /go/bin/ /usr/bin/
COPY --from=par /par2cmdline/par2 /usr/bin
RUN  apk upgrade --update && \
    apk add --update --no-cache libcap alpine-conf unrar unzip python3 python3-dev rust sudo cargo libffi-dev libressl-dev curl ffmpeg mkvtoolnix file jq  && \
    curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest | jq '.assets[] | select(.content_type=="application/x-tar").browser_download_url' | xargs curl -Lo sab.tar.gz && \
    python3 -m ensurepip  && \
    pip3 install --upgrade pip setuptools wheel && \
    mkdir /sabnzbd && \
    tar -xvf sab.tar.gz -C /sabnzbd --strip-components 1 && \
    rm sab.tar.gz && \
    cd /sabnzbd && \
    python3 -m pip install -r requirements.txt -U && \
    setup-timezone -z ${TZ} && \
    apk del python3-dev libffi-dev libressl-dev gcc rust cargo curl alpine-conf && \
    adduser -D ${USER} && \
    echo "jeremy ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /var/cache/apk/* && \
    ln -sf /usr/bin/par2 /usr/bin/par2create && \
    ln -sf /usr/bin/par2 /usr/bin/par2verify && \
    ln -sf /usr/bin/par2 /usr/bin/par2repair && \
    setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/python3.9 && \
    touch /sabnzbd.sh && chmod +x /sabnzbd.sh && \
    printf '#!/bin/sh\n' > /sabnzbd.sh && \
    printf 'sudo ip route del default\n' >> /sabnzbd.sh && \
    printf 'sudo ip route add default via 192.168.0.1 dev eth0\n' >> /sabnzbd.sh && \
    printf '/sabnzbd/SABnzbd.py --logging 1 --browser 0\n' >> /sabnzbd.sh
USER ${USER}
CMD /sabnzbd.sh

