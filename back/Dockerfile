ARG ARG_PLATFORM ARG_RUBY_VERSION=default
FROM --platform=${ARG_PLATFORM} ruby:${ARG_RUBY_VERSION}-slim-bookworm
SHELL ["/bin/sh", "-c"]

ARG ARG_PLATFORM ARG_RUBY_VERSION
ENV PLATFORM=${ARG_PLATFORM} RUBY_VERSION=${ARG_RUBY_VERSION} DEBIAN_FRONTEND=noninteractive

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

ARG ARG_BUNDLER_VERSION
ENV BUNDLER_VERSION=$ARG_BUNDLER_VERSION
RUN gem install bundler -v $BUNDLER_VERSION && \
  chown user:user -R /usr/local/bundle

USER user
WORKDIR /home/user

RUN sudo apt install -y \
  libpq-dev \
  postgresql-client \
  nginx \
  nginx-extras \
  libnss3-tools \
  stress-ng \
  cron

RUN wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 && \
  sudo mv mkcert-v1.4.4-linux-amd64 /usr/local/bin/mkcert && \
  sudo chmod +x /usr/local/bin/mkcert && \
  sudo chown user:user -R /etc/nginx

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" && \
  sudo apt install -y unzip && \
  unzip awscliv2.zip && \
  sudo ./aws/install && \
  sudo rm -rf ./aws
