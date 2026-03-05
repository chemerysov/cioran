#!/bin/bash

cd "$(dirname "$0")/.."
if test -d "./certbot/conf/live/cioran.org"; then
    echo "Existing certificates found. Skipping initialization."
    exit 0
fi

echo "### Creating dummy certificate..."
docker compose run --rm --entrypoint \
    "openssl req -x509 -nodes -newkey rsa:4096 -days 1 \
    -keyout /etc/letsencrypt/live/cioran.org/privkey.pem \
    -out /etc/letsencrypt/live/cioran.org/fullchain.pem \
    -subj '/CN=localhost'" \
    certbot

echo "### Starting nginx in production mode..."
docker compose -f docker-compose.yml -f docker-compose.prod.yml \
    up --force-recreate -d nginx

echo "### Deleting dummy certificate..."
docker compose run --rm --entrypoint \
    "rm -rf /etc/letsencrypt/live/cioran.org \
    /etc/letsencrypt/archive/cioran.org" \
    certbot

echo "### Requesting real certificate..."
docker compose run --rm --entrypoint \
    "certbot certonly --webroot --webroot-path /var/www/certbot/ \
    -d cioran.org -d www.cioran.org \
    --email achemerysov@gmail.com --agree-tos --no-eff-email" \
    certbot

echo "### Reloading nginx..."
docker compose -f docker-compose.yml -f docker-compose.prod.yml \
    exec nginx nginx -s reload