FROM neilpang/acme.sh

# 安裝必要的工具和 Nginx
RUN apk update && \
    apk add --no-cache nginx openrc bash openssl curl supervisor && \
    rm -rf /var/cache/apk/*

# 創建目錄並設置權限
RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx && \
    mkdir -p /var/lib/nginx && \
    mkdir -p /var/log/nginx && \
    mkdir -p /var/www/html

RUN rm /acme.sh/account.conf

# 複製 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf
COPY renew_certificates.sh /renew_certificates.sh

RUN mkdir -p /run/nginx /etc/nginx /var/lib/nginx /var/log/nginx /var/www/html /etc/nginx/cert

# 暴露端口
EXPOSE 80 443

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
