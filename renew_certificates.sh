#!/bin/sh

acme.sh --update-account --accountemail ${ACME_SH_EMAIL}

# 將變量轉換為數組
DOMAIN_ARRAY=$(echo $DOMAINS | tr " " "\n")

i=0
for DOMAIN in $DOMAIN_ARRAY; do
WILDCARD_DOMAIN=*."${DOMAIN}"

echo "生成證書 ${DOMAIN} and ${WILDCARD_DOMAIN}"

acme.sh --issue -d "${DOMAIN}" -d "${WILDCARD_DOMAIN}" --dns "${DNS_API}" --server letsencrypt --log --nginx

mkdir -p /etc/nginx/cert/$DOMAIN

# 主要域名
acme.sh --install-cert -d "${DOMAIN}" \
        --key-file /etc/nginx/cert/"${DOMAIN}"/"${DOMAIN}".key \
        --fullchain-file /etc/nginx/cert/"${DOMAIN}"/"${DOMAIN}".fullchain \
        --reloadcmd "nginx -s reload"

# 子域名
acme.sh --install-cert -d "${DOMAIN}" \
        --key-file /etc/nginx/cert/"${DOMAIN}"/"${WILDCARD_DOMAIN}".key \
        --fullchain-file /etc/nginx/cert/"${DOMAIN}"/"${WILDCARD_DOMAIN}".fullchain \
        --reloadcmd "nginx -s reload"

acme.sh --info -d "${DOMAIN}"
acme.sh --info -d "${WILDCARD_DOMAIN}"

i=$((i + 1))
done

acme.sh --upgrade
acme.sh list

nginx -g "daemon off;"
