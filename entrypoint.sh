#!/bin/bash

#set -eo pipefail

#extract edusoho
tar zxvf /var/www/edusoho-${EDUSOHO_VERSION}.tar.gz -C /var/www && rm -rf /var/www/edusoho-${EDUSOHO_VERSION}.tar.gz

#specify domain for nginx vhost
if [ -z "$DOMAIN" ]; then
    echo >&2 'required option: -e DOMAIN="your_domain"'
    exit 1
fi
sed -i "s/{{DOMAIN}}/${DOMAIN}/g" /etc/nginx/sites-enabled/edusoho.conf

#init datadir if mount dir outside to /var/lib/mysql
mysql_install_db

#start services
echo 'starting nginx'
/etc/init.d/nginx start
echo 'nginx is running'

echo 'starting php5-fpm'
/etc/init.d/php5-fpm start
echo 'php5-fpm is running'

echo 'starting mysql'
/etc/init.d/mysql start
mysql_root='mysql -uroot'
# echo 'SELECT 1' | ${mysql_root} &> /dev/null
# if [ "$?" -ne 0 ]; then
#     echo >&2 'mysql start failed.'
#     exit 1
# fi
for i in {10..0}; do
    if echo 'SELECT 1' | ${mysql_root} &> /dev/null; then
        break
    fi
    echo '.'
    sleep 1
done
if [ "$i" = 0 ]; then
    echo >&2 'mysql start failed.'
    exit 1
else
    echo 'mysql is running'
    #mysqladmin -u root password root

    #create empty database
    echo 'CREATE DATABASE IF NOT EXISTS `edusoho` DEFAULT CHARACTER SET utf8 ;' | ${mysql_root}
    echo 'GRANT ALL PRIVILEGES ON `edusoho`.* TO "esuser"@"localhost" IDENTIFIED BY "edusoho";' | ${mysql_root}
    echo 'create database for edusoho successfully'
    echo '***************************'
    echo '* welcome to use edusoho! *'
    echo '* --- www.edusoho.com --- *'
    echo '***************************'
fi

