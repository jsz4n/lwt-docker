FROM alpine:3.13
RUN apk update
RUN apk upgrade
RUN apk add php curl apache2 php7-apache2 php-mbstring
RUN apk add  php7-mysqlnd php7-mysqli php7-curl php7-session php7-json

RUN mkdir -p /var/www/media && chmod -R 755 /var/www
RUN wget https://sourceforge.net/projects/learning-with-texts/files/latest/download -O /var/www/lwt.zip

WORKDIR /var/www/

RUN unzip /var/www/lwt.zip
RUN rm /var/www/*.txt
RUN unzip /var/www/lwt_v_2_0_2.zip
RUN cp /var/www/connect_xampp.inc.php /var/www/connect.inc.php
RUN sed -i 's/\$passwd = "";/\$passwd = getenv("MARIADB_ROOT_PASSWORD");/g' /var/www/connect.inc.php
RUN sed -i 's/\$server = "localhost";/\$server = getenv("MARIADB_SERVER");/g' /var/www/connect.inc.php

ADD httpd.conf /etc/apache2/httpd.conf

EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]
