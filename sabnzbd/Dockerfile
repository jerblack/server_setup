# syntax=docker/dockerfile:1.2

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
    go get github.com/jerblack/server_tools/mux && \
    go get github.com/jerblack/server_tools/extract 
    
FROM alpine
ARG TZ
ARG USER
ARG SERVER_PORT
ENV SERVER_PORT ${SERVER_PORT}
WORKDIR /config/
COPY --from=build /go/bin/ /usr/bin/
COPY --from=par /par2cmdline/par2 /usr/bin
RUN --mount=type=cache,target=/root/.cache/  \
    apk upgrade --update && \
    apk add --update --no-cache alpine-conf unrar unzip python3 python3-dev rust cargo libffi-dev libressl-dev curl ffmpeg mkvtoolnix file jq  && \
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
    rm -rf /var/cache/apk/* && \
    ln -sf /usr/bin/par2 /usr/bin/par2create && \
    ln -sf /usr/bin/par2 /usr/bin/par2verify && \
    ln -sf /usr/bin/par2 /usr/bin/par2repair
USER ${USER}
CMD /sabnzbd/SABnzbd.py --logging 1 --browser 0 --server 0.0.0.0:${SERVER_PORT}

