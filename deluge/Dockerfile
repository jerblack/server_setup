FROM debian:buster-slim
ARG TZ
ARG USER
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y deluged=1.3.15-2 deluge-console=1.3.15-2 htop iproute2 iputils-ping dnsutils && \
    apt-get clean && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    useradd --create-home --shell /bin/bash ${USER}
USER ${USER}
CMD [ "deluged", "-d" ]


# docker build --rm --no-cache -t deluge .
# docker run --name dg -v /x/deluge_pub:/root/.config/deluge  --network=container:vpn --rm -it deluge bash