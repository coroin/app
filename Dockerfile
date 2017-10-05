FROM debian:stretch-slim

MAINTAINER Coroin LLC <info@coroin.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
    && apt install --no-install-recommends --no-install-suggests -q -y \
        apt-transport-https ca-certificates curl git lsb-release nano unzip wget zip \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
    && apt update \
    && apt install -y nginx nodejs php7.1-fpm php7.1-curl php7.1-gd php7.1-imap php7.1-mbstring \
        php7.1-mcrypt php7.1-memcached php7.1-mysql php7.1-soap php7.1-xml php7.1-xdebug php7.1-zip supervisor \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir -p /run/php7.1 \
    && apt -y autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD ["/usr/bin/supervisord"]

COPY etc/ /etc/