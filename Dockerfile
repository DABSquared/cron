FROM dabsquared/php-fpm

LABEL maintainer "dbrooks@dabsquared.com"

RUN apt-get update && apt-get install -y cron

WORKDIR /var/www/symfony

ENV CRONTAB_CONF ""
ENV WAIT_FOR_PHP "false"

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["cron", "-f"]

HEALTHCHECK CMD exit 0
