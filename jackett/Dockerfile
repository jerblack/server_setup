# syntax=docker/dockerfile:1.2

FROM debian:buster-slim
ARG TZ
ARG USER
RUN apt-get update && \
    apt-get install -y libicu63 libssl1.0 wget sudo curl && \
    apt-get clean && \
	useradd --create-home --shell /bin/bash ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    curl -s https://api.github.com/repos/Jackett/Jackett/releases/latest | grep -wo "https.*LinuxAMDx64.tar.gz" | wget -qi - && \
    tar -xvf Jackett.Binaries.LinuxAMDx64.tar.gz && \
    rm Jackett.Binaries.LinuxAMDx64.tar.gz && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
WORKDIR /Jackett/
USER ${USER}
CMD ["./jackett_launcher.sh"]
