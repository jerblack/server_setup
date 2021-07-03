# syntax=docker/dockerfile:1.2

FROM debian:buster-slim
ARG TZ
ARG USER
RUN apt-get update && \
    apt-get install -y libicu63 libssl1.0 curl jq sudo && \
    apt-get clean && \
	  useradd --create-home --shell /bin/bash ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    curl -s https://api.github.com/repos/Jackett/Jackett/releases/latest | jq -r '.assets[] | select(.name=="Jackett.Binaries.LinuxAMDx64.tar.gz").browser_download_url' | xargs curl -sLo jackett.tar.gz && \
    tar -xvf jackett.tar.gz && \
    rm jackett.tar.gz && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    apt-get remove -y curl jq
WORKDIR /Jackett/
USER ${USER}
CMD ["./jackett_launcher.sh"]
