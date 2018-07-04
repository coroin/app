FROM debian:stretch-slim

MAINTAINER Coroin LLC <info@coroin.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -q -y \
        apt-transport-https ca-certificates curl git lsb-release nano unzip wget zip \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
    && apt-get update \
    && apt-get install -y nginx nodejs php7.2-fpm php7.2-curl php7.2-gd php7.2-imap php7.2-mbstring \
        php7.2-memcached php7.2-mysql php7.2-soap php7.2-xml php7.2-xdebug php7.2-zip supervisor \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir -p /run/php7.2 \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD ["/usr/bin/supervisord"]

COPY etc/ /etc/
