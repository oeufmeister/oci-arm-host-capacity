FROM alpine

COPY . /oci-arm-host-capacityy

WORKDIR /oci-arm-host-capacityy

COPY .env.example .env

RUN apk update && apk upgrade --available
RUN apk --update add wget \ 
            nano \
            curl \
            git \
            php \
            php-curl \
            php-phar \
            php-openssl \
            php-iconv \
            php-mbstring \
            php-json \
            openrc --no-cache \
            busybox-openrc\
            php7-dom --repository http://nl.alpinelinux.org/alpine/edge/testing/ && rm /var/cache/apk/*
            

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer 

RUN composer install --ignore-platform-reqs

RUN touch /oci-arm-host-capacityy/oci.log

RUN chmod 777 /oci-arm-host-capacityy/oci.log

RUN (crontab -l ; echo "* * * * * /usr/bin/php /oci-arm-host-capacityy/index.php >> /oci-arm-host-capacityy/oci.log") | crontab -

CMD [ "php", "./index.php" ]