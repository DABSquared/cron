#!/bin/bash
set -e

if [[ -z "$GIT_REPO" && -z "$GIT_SSH_KEY" ]]
then
    echo "No GIT Repository defined, not pulling."
    if [ "$WAIT_FOR_PHP" == "true" ]; then
        while true
        do
          [ -f .php_setup ] && break
          sleep 2
        done
    fi
else
    echo "Pulling GIT Repository to /var/www/symfony"
    mkdir -p ~/.ssh
    eval "$(ssh-agent)" && ssh-agent -s
    echo "$GIT_SSH_KEY" > ~/.ssh/id_rsa
    chmod -R 0600 ~/.ssh/id_rsa
    ssh-add ~/.ssh/id_rsa
    [[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
    cd /var/www
    git clone "$GIT_REPO" symfony
    /setup.sh
fi

if [ "$CRONTAB_CONF" ]; then
    cp /var/www/symfony/$CRONTAB_CONF /etc/cron.d/symfony
    sed -i.bak 's/symfony_app_name/'"$symfony_app_name"'/g' /etc/cron.d/symfony
    sed -i.bak 's/ENVIRONMENT/'"$ENVIRONMENT"'/g' /etc/cron.d/symfony
    rm -rf /etc/cron.d/symfony.bak
    chmod 0644 /etc/cron.d/symfony
fi

exec "$@"