FROM debian:stretch-slim

MAINTAINER Coroin LLC <info@coroin.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
    && apt install -y curl git nano nginx nodejs php-fpm php-curl php-gd php-imap php-mbstring \
        php-mcrypt php-memcached php-mysql php-xml php-xdebug php-zip supervisor unzip zip \
    && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && mkdir -p /run/php \
    && apt -y autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD ["/usr/bin/supervisord"]

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf
COPY php-www.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY nginx-http /etc/nginx/sites-available/default
