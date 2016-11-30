FROM debian:7

MAINTAINER Simon Wood <cfansimon@hotmail.com>

ENV DOMAIN              demo.st.edusoho.cn
ENV EDUSOHO_VERSION     7.2.9
ENV TIMEZONE            Asia/Shanghai
ENV PHP_MEMORY_LIMIT    1024M
ENV MAX_UPLOAD          1024M
ENV PHP_MAX_POST        1024M

#init
RUN apt-get update && apt-get install -y tzdata && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo "${TIMEZONE}" > /etc/timezone
RUN apt-get install -y wget

#nginx
RUN apt-get install -y nginx
RUN lineNum=`sed -n  -e '/sendfile/=' /etc/nginx/nginx.conf`; sed -i $((lineNum+1))'i client_max_body_size 1024M;' /etc/nginx/nginx.conf
RUN sed -i '1i daemon off;' /etc/nginx/nginx.conf
COPY nginx/edusoho.conf /etc/nginx/sites-enabled
COPY nginx/entrypoint.sh /usr/local/bin/nginx-entrypoint.sh

#php
RUN apt-get install -y php5 php5-cli php5-curl php5-fpm php5-intl php5-mcrypt php5-mysqlnd php5-gd
#php-fpm.conf
RUN sed -i "s/;*daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;*listen.owner\s*=\s*www-data/listen.owner = www-data/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;*listen.group\s*=\s*www-data/listen.group = www-data/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/;*listen.mode\s*=\s*0660/listen.mode = 0660/g" /etc/php5/fpm/php-fpm.conf
#php.ini
RUN sed -i "s/;*post_max_size\s*=\s*\d*M/post_max_size = ${PHP_MAX_POST}M/g" /etc/php5/fpm/php.ini
RUN sed -i "s/;*memory_limit\s*=\s*\d*M/memory_limit = ${PHP_MEMORY_LIMIT}M/g" /etc/php5/fpm/php.ini
RUN sed -i "s/;*upload_max_filesize\s*=\s*\d*M/upload_max_filesize = ${MAX_UPLOAD}M/g" /etc/php5/fpm/php.ini

#mysql
RUN apt-get -y install mysql-server
COPY mysql/entrypoint.sh /usr/local/bin/mysql-entrypoint.sh

#edusoho configuration
RUN mkdir -p /var/www
RUN wget http://download.edusoho.com/edusoho-${EDUSOHO_VERSION}.tar.gz
RUN tar zxvf edusoho-${EDUSOHO_VERSION}.tar.gz && rm -rf edusoho-${EDUSOHO_VERSION}.tar.gz

EXPOSE 80
CMD ["nginx-entrypoint.sh", "php5-fpm", "mysql-entrypoint.sh"]