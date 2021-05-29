FROM ubuntu:latest

ENV DISPLAY=192.168.0.10:0
ENV GTK_THEME=Adwaita:dark
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y adwaita-icon-theme fonts-cantarell deluge-gtk 
CMD ["deluge-gtk"]