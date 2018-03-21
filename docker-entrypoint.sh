#!/bin/bash
set -e

if [ "$ISDEV" == "false" ]; then
    php -d newrelic.appname="$symfony_app_name" bin/console --env="$ENVIRONMENT" doctrine:migrations:migrate --no-interaction || (echo >&2 "Doctrine Migrations Failed" && exit 1)
    php -d newrelic.appname="$symfony_app_name" bin/console --env="$ENVIRONMENT" cache:warmup || (echo >&2 "Cache Warmup Dev Failed" && exit 1)
fi

if [ "$CRONTAB_CONF" ]; then
    cp /var/www/symfony/$CRONTAB_CONF /etc/cron.d/symfony
    sed -i.bak 's/symfony_app_name/'"$symfony_app_name"'/g' /etc/cron.d/symfony
    sed -i.bak 's/ENVIRONMENT/'"$ENVIRONMENT"'/g' /etc/cron.d/symfony
    rm -rf /etc/cron.d/symfony.bak
    chmod 0644 /etc/cron.d/symfony
fi

touch /var/log/cron.log
printenv | sed '/^\s*$/d' | sed 's/^\(.*\)$/export "\1"/g' > /root/project_env.sh
chmod a+x /root/project_env.sh
cron

exec "$@"
