# syntax=docker/dockerfile:1.2

FROM alpine
ARG TZ
ARG USER
RUN \
  apk upgrade --update && \
  apk add --no-cache git python3 python3-dev curl jq alpine-conf && \
  python3 -m ensurepip  && \
  pip3 install --upgrade pip setuptools wheel && \
  adduser -D jeremy && \
  setup-timezone -z ${TZ} && \
  VER=$(curl -s https://api.github.com/repos/Tautulli/Tautulli/releases/latest | jq -r .tag_name) && \
  curl -o tautulli.tar.gz -sL "https://github.com/Tautulli/Tautulli/archive/${VER}.tar.gz" && \
  mkdir /tautulli && \
  tar -xovf tautulli.tar.gz -C /tautulli --strip-components 1 && \
  chown -R jeremy:jeremy /tautulli && \
  rm /tautulli.tar.gz && \
  apk del curl jq alpine-conf && \
  rm -rf /var/cache/apk/*
USER ${USER}
CMD [ "python3", "tautulli/Tautulli.py", "--datadir", "/config" ]