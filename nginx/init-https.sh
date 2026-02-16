#!/bin/bash

DOMAINS=(cioran.org www.cioran.org)
EMAIL="achemerysov@gmail.com"
DATA_PATH="./certbot"
cd "$(dirname "$0")/.."

if [ -d "$DATA_PATH/conf/live/${DOMAINS[0]}" ]; then
    echo "Existing certificates found. Skipping initialization."
    exit 0
fi

echo "### Creating dummy certificate..."
docker compose run --rm --entrypoint \
    "openssl req -x509 -nodes -newkey rsa:4096 -days 1 \
    -keyout /etc/letsencrypt/live/${DOMAINS[0]}/privkey.pem \
    -out /etc/letsencrypt/live/${DOMAINS[0]}/fullchain.pem \
    -subj '/CN=localhost'" certbot

echo "### Starting nginx in production mode..."
docker compose -f docker-compose.yml -f docker-compose.prod.yml up --force-recreate -d nginx

echo "### Deleting dummy certificate..."
docker compose run --rm --entrypoint \
    "rm -rf /etc/letsencrypt/live/${DOMAINS[0]} /etc/letsencrypt/archive/${DOMAINS[0]}" certbot

echo "### Requesting real certificate..."
domain_args=""
for domain in "${DOMAINS[@]}"; do
    domain_args="$domain_args -d $domain"
done

docker compose run --rm --entrypoint "certbot certonly --webroot --webroot-path=/var/www/certbot \
    $domain_args \
    --email $EMAIL --agree-tos --no-eff-email" certbot

echo "### Reloading nginx..."
docker compose -f docker-compose.yml -f docker-compose.prod.yml exec nginx nginx -s reload