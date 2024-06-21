FROM neilpang/acme.sh

# 安裝必要的工具和 Nginx
RUN apk update && \
    apk add --no-cache nginx openrc bash openssl curl && \
    rm -rf /var/cache/apk/*

# 創建目錄並設置權限
RUN mkdir -p /run/nginx && \
    mkdir -p /etc/nginx && \
    mkdir -p /var/lib/nginx && \
    mkdir -p /var/log/nginx && \
    mkdir -p /var/www/html

# 複製 Nginx 配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80 443

# CMD ["nginx", "-g", "daemon off;"]
