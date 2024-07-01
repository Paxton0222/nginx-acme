#!/bin/sh

if [ ! -f /acme.sh/account.conf ]; then
    echo "第一次啟動"
    acme.sh --register-account --accountemail $ACME_SH_EMAIL
    acme.sh --update-account --accountemail $ACME_SH_EMAIL

    # 將變量轉換為數組
    DOMAIN_ARRAY=$(echo $DOMAINS | tr " " "\n")

    i=0
    for DOMAIN in $DOMAIN_ARRAY; do
	WILDCARD_DOMAIN=*."${DOMAIN}"

	echo "生成證書 ${DOMAIN} and ${WILDCARD_DOMAIN}"

	acme.sh --issue -d "${DOMAIN}" -d "${WILDCARD_DOMAIN}" --dns "${DNS_API}" --server letsencrypt --log

	mkdir -p /etc/nginx/cert/$DOMAIN
    mkdir -p /etc/nginx/cert/$WILCARD_DOMAIN

	# 主要域名
	acme.sh --install-cert -d "${DOMAIN}" \
        	--key-file /etc/nginx/cert/$DOMAIN/key.pem \
        	--fullchain-file /etc/nginx/cert/$DOMAIN/fullchain.pem \
        	--reloadcmd "nginx -s reload"

	# 子域名
	acme.sh --install-cert -d $WILCARD_DOMAIN \
	        --key-file /etc/nginx/cert/$WILDCARD_DOMAIN/key.pem \
        	--fullchain-file /etc/nginx/cert/$WILDCARD_DOMAIM/fullchain.pem \
        	--reloadcmd "nginx -s reload"

	acme.sh --info -d "${DOMAIN}"
	acme.sh --info -d "${WILDCARD_DOMAIN}"

	i=$((i + 1))
	done
fi

acme.sh --upgrade --auto-upgrade
acme.sh --list

/entry.sh daemon

