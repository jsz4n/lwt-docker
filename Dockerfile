FROM alpine:3.18
RUN apk update
RUN apk upgrade

RUN apk add php82 curl apache2 php82-apache2 php82-mbstring
RUN apk add php82-mysqlnd php82-mysqli php82-curl php82-session php81-json

RUN mkdir -p /var/www/media && chmod -R 755 /var/www
RUN wget https://sourceforge.net/projects/learning-with-texts/files/learning_with_texts_2_0_3_complete.zip/download -O /var/www/lwt.zip

WORKDIR /var/www/

RUN unzip /var/www/lwt.zip
RUN rm /var/www/*.txt
RUN unzip /var/www/lwt_v_2_0_3.zip
RUN cp /var/www/connect_xampp.inc.php /var/www/connect.inc.php
RUN sed -i 's/\$userid = "root";/\$userid = getenv("MARIADB_USER");/g' /var/www/connect.inc.php
RUN sed -i 's/\$passwd = "";/\$passwd = getenv("MARIADB_PASSWORD");/g' /var/www/connect.inc.php
RUN sed -i 's/\$server = "localhost";/\$server = getenv("MARIADB_SERVER");/g' /var/www/connect.inc.php

ADD httpd.conf /etc/apache2/httpd.conf

EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]
