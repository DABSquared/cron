#!/bin/bash
set -e

if [ "$1" = 'cron' ]; then
	if [ "$CRONTAB_CONF" ]; then
        cp $CRONTAB_CONF /etc/cron.d/symfony
        chmod 644 /etc/cron.d/symfony
    fi
fi

exec "$@"


