# syntax=docker/dockerfile:1.2

FROM alpine AS par
RUN apk add --update libffi-dev libressl-dev git automake make bash autoconf alpine-sdk && \
    git clone https://github.com/Parchive/par2cmdline.git  && \
    cd par2cmdline && \
    aclocal && \
    automake --add-missing && \
    autoconf && \
    ./configure && \
    make && \
    make install && \
    tar -cvf /par.tar /usr/lib/libgcc_s.so.1 /usr/lib/libgomp.so.1 /usr/lib/libgomp.so.1.0.0 \
    /usr/lib/libgomp.so /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so /usr/lib/libstdc++.so.6.0.28 /usr/local/bin/par2

FROM golang:alpine as mux
ENV CGO_ENABLED=0
RUN apk add --no-cache subversion && \
    svn export https://github.com/jerblack/server_tools/trunk/mux && \
    cd mux && \
    go build -ldflags="-s -w"

FROM golang:alpine as extract
ENV CGO_ENABLED=0
RUN apk add --no-cache subversion && \
    svn export https://github.com/jerblack/server_tools/trunk/extract && \
    cd extract && \
    go build -ldflags="-s -w"

FROM alpine
ARG TZ
ARG USER
ARG SERVER_PORT
ENV SERVER_PORT ${SERVER_PORT}
WORKDIR /config/
COPY --from=par /par.tar .
COPY --from=mux /go/mux/mux /usr/bin/mux
COPY --from=extract /go/extract/extract /usr/bin/extract
RUN --mount=type=cache,target=/root/.cache/  \
    apk upgrade --update && \
    apk add --update --no-cache alpine-conf unrar unzip sudo python3 python3-dev rust cargo libffi-dev libressl-dev curl wget ffmpeg mkvtoolnix file jq  && \
    # curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest | grep -wo "https.*src.tar.gz" | wget -qi -  && \
    curl -s https://api.github.com/repos/sabnzbd/sabnzbd/releases/latest | jq '.assets[] | select(.content_type=="application/x-tar").browser_download_url' | wget -qi -  && \
    python3 -m ensurepip  && \
    pip3 install --upgrade pip setuptools wheel && \
    mkdir /sabnzbd && \
    tar -xvf SAB*src.tar.gz -C /sabnzbd --strip-components 1 && \
    cd /sabnzbd && \
    python3 -m pip install -r requirements.txt -U && \
    setup-timezone -z ${TZ} && \
    apk del python3-dev libffi-dev libressl-dev gcc rust cargo curl wget alpine-conf && \
    adduser -D ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    rm -rf /var/cache/apk/* && \
    tar -xvf /config/par.tar -C / && \
    ln -sf /usr/local/bin/par2 /usr/local/bin/par2create && \
    ln -sf /usr/local/bin/par2 /usr/local/bin/par2verify && \
    ln -sf /usr/local/bin/par2 /usr/local/bin/par2repair
USER ${USER}
CMD /sabnzbd/SABnzbd.py --logging 1 --browser 0 --server 0.0.0.0:${SERVER_PORT}

