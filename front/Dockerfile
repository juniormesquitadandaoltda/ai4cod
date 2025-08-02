ARG ARG_PLATFORM ARG_NODE_VERSION=default
FROM --platform=${ARG_PLATFORM} node:${ARG_NODE_VERSION}-bookworm-slim
SHELL ["/bin/sh", "-c"]

ARG ARG_PLATFORM ARG_NODE_VERSION
ENV PLATFORM=${ARG_PLATFORM} NODE_VERSION=${ARG_NODE_VERSION} DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt upgrade -y && \
  apt install -y \
    sudo \
    locales-all \
    bash-completion \
    dh-autoreconf \
    cmake \
    git-core \
    curl \
    wget \
    zip \
    glibc-source \
    vim && \
  update-alternatives --config editor && \
  apt autoremove --purge && \
  apt autoclean

ARG ARG_LINUX_LOCALE
ENV LINUX_LOCALE=$ARG_LINUX_LOCALE
ENV LC_ALL=$LINUX_LOCALE LANG=$LINUX_LOCALE LANGUAGE=$LINUX_LOCALE

ARG ARG_USER_UID ARG_USER_GID
ARG USER_UID=$ARG_USER_UID USER_GID=$ARG_USER_GID
RUN getent passwd $USER_UID | cut -d: -f1 | { read username; [ -z "$username" ] && exit 0 || deluser --remove-home $username; } && \
  getent group $USER_GID | cut -d: -f1 | { read groupname; [ -z "$groupname" ] && exit 0 || delgroup --remove-home $groupname; } && \
  addgroup --gid $USER_GID user && \
  adduser --disabled-password --gecos '' --uid  $USER_UID --gid $USER_GID user && \
  passwd -d root && \
  echo 'user ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers && \
  chown user:user -R /usr/local

ARG ARG_NPM_VERSION
ENV NPM_VERSION=$ARG_NPM_VERSION
RUN npm install -g "npm@${NPM_VERSION}" && \
  rm -rf $(which yarn)

USER user
WORKDIR /home/user

RUN sudo apt install jq -y
