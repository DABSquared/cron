#!/bin/bash
set -e

if [ "$CRONTAB_CONF" ]; then
    cp $CRONTAB_CONF /etc/cron.d/symfony
    sed -i.bak 's/symfony_app_name/'"$symfony_app_name"'/g' /etc/cron.d/symfony
    sed -i.bak 's/ENVIRONMENT/'"$ENVIRONMENT"'/g' /etc/cron.d/symfony
    rm -rf /etc/cron.d/symfony.bak
    chmod 0644 /etc/cron.d/symfony
fi

if [ "$WAIT_FOR_PHP" == "true" ]; then
    while true
    do
      [ -f .php_setup ] && break
      sleep 2
    done
fi

exec "$@"