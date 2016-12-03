#!/bin/bash

#extract edusoho
tar zxvf -C /var/www edusoho-${EDUSOHO_VERSION}.tar.gz && rm -rf /var/www/edusoho-${EDUSOHO_VERSION}.tar.gz

#specify domain for nginx vhost
sed -i "s/{{DOMAIN}}/${DOMAIN}/g" /etc/nginx/sites-enabled/edusoho.conf

#init datadir if mount dir outside to /var/lib/mysql
echo 'stopping mysql'
/etc/init.d/mysql stop
mysql_install_db

#create empty database


#start services
echo 'starting nginx'
/etc/init.d/nginx start
echo 'nginx is running'

echo 'starting php5-fpm'
/etc/init.d/php5-fpm start
echo 'php5-fpm is running'

echo 'starting nginx'
/etc/init.d/mysql start
echo 'mysql is running'
