# FROM ubuntu:latest as libtorrent_latest
# ENV  DEBIAN_FRONTEND=noninteractive
# RUN apt-get update && \
#     apt-get upgrade -y && \
#     apt-get install -y curl libboost-tools-dev libboost-dev libboost-python-dev libboost-system-dev build-essential libssl-dev build-essential python3-pip jq && \
#     LT_URL=$(curl -s -H "Accept: application/json"   https://api.github.com/repos/arvidn/libtorrent/releases | jq -r '.[] |  select(.target_commitish=="RC_1_2").assets[].browser_download_url' | head -n 1) && \
#     curl -Lo libtorrent.tar.gz $LT_URL && \
#     mkdir libtorrent && \
#     tar xf libtorrent.tar.gz -C libtorrent --strip 1 && \
#     cd /libtorrent/bindings/python && \
#     python3 setup.py build_ext --b2-args="libtorrent-link=static crypto=openssl" bdist_wheel
FROM ubuntu:latest as libtorrent1_2_13
ENV  DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl libboost-tools-dev libboost-dev libboost-python-dev libboost-system-dev build-essential libssl-dev build-essential python3-pip && \
    curl -Lo libtorrent.tar.gz https://github.com/arvidn/libtorrent/releases/download/v1.2.13/libtorrent-rasterbar-1.2.13.tar.gz && \
    mkdir libtorrent && \
    tar xf libtorrent.tar.gz -C libtorrent --strip 1 && \
    cd /libtorrent/bindings/python && \
    python3 setup.py build_ext --b2-args="libtorrent-link=static crypto=openssl" bdist_wheel


FROM ubuntu:latest
ARG TZ
ARG USER
ENV DEBIAN_FRONTEND=noninteractive
COPY --from=libtorrent1_2_13 /libtorrent/bindings/python/dist/ /wheel/
RUN  apt-get update && \
     apt-get upgrade -y && \
     apt-get install -y deluged python3-pip && \
     apt-get clean && \
     ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
     useradd --create-home --shell /bin/bash ${USER} && \
     WHL=$(ls /wheel/*whl) && \
     python3 -m pip install $WHL
USER ${USER}
CMD [ "deluged", "-d" ]



# docker build --rm --no-cache -t deluge .
# docker run --name dg -v /x/deluge_pub:/root/.config/deluge  --network=container:vpn --rm -it deluge bash