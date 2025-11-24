FROM ghcr.io/sa4zet-org/docker.img.debian:latest AS build-stage

ARG docker_img
ENV DOCKER_TAG=$docker_img

RUN apt-get update \
  && apt-get -y install \
    libnginx-mod-http-headers-more-filter \
    nginx \
    php-cli \
    php-common \
    php-curl \
    php-fpm \
    php-mbstring \
    php-opcache \
    php-readline \
    php-sqlite3 \
    php-xml

COPY etc/ /etc/
COPY --chmod=700 entrypoint.sh /entrypoint.sh

RUN apt-get --purge -y autoremove \
    && apt-get clean \
    && rm -rf /tmp/* /var/lib/apt/lists/*

FROM ghcr.io/sa4zet-org/docker.img.debian:latest AS final-stage
COPY --from=build-stage / /

ENV DOCKER_TAG=ghcr.io/sa4zet-org/docker.img.mail

ENTRYPOINT ["/entrypoint.sh"]
