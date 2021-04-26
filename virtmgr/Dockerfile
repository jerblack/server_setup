FROM alpine
ARG TZ
ARG USER
ENV DISPLAY=192.168.0.10:0
ENV GTK_THEME=Adwaita:dark
RUN apk upgrade --update && \
    apk add virt-manager openssh-client alpine-conf ttf-cantarell adwaita-icon-theme && \
    setup-timezone -z ${TZ} && \
    apk del alpine-conf && \
    rm -rf /var/cache/apk/* && \
    adduser ${USER} -D
USER ${USER}
CMD [ "virt-manager", "-c", "qemu+ssh://root@192.168.0.5/system", "--no-fork" ]

# docker build -t virtmgr .
# docker run -v /x:/x -v /x/.config/docker/.secrets/.ssh:/home/jeremy/.ssh --net bridge --rm -it virtmgr bash
# docker run -v /x:/x --net bridge --rm -it -u 0 virtmgr sh



# valid id_rsa id_rsa.pub known_hosts for root on kvm server must be in ~/.ssh
#   .ssh files need chmod 0600 *
# qemu+ssh://root@192.168.0.5/system

# Connects virt-manager GUI to x server running on remote machine
# Windows x server: https://sourceforge.net/projects/vcxsrv/
# Start Xlaunch > Multiple windows > Start no client > Clipboard, Primary Selection, & Disable access control > Save config and finish