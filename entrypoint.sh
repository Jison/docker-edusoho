#!/bin/bash

#set -eo pipefail

#check required env vars
if [ -z "$DOMAIN" ]; then
    echo >&2 'required option: -e DOMAIN="your_domain"'
    exit 1
fi

hasInitd=
if [ -f "/.entrypoint-initd.lock" ]; then
    hasInitd=true
else
    hasInitd=false
fi

if [ !hasInitd ]; then
    #extract edusoho
    tar zxvf /var/www/edusoho-${EDUSOHO_VERSION}.tar.gz -C /var/www && chown -R www-data:www-data /var/www/edusoho && rm -rf /var/www/edusoho-${EDUSOHO_VERSION}.tar.gz
    touch /.entrypoint-initd.lock

    #mofidy domain for nginx vhost
    sed -i "s/{{DOMAIN}}/${DOMAIN}/g" /etc/nginx/sites-enabled/edusoho.conf

fi

echo 'starting php5-fpm'
/etc/init.d/php5-fpm start >& /dev/null

echo 'starting nginx'
echo '***************************'
echo '* welcome to use edusoho! *'
echo '* --- www.edusoho.com --- *'
echo '***************************'
nginx
