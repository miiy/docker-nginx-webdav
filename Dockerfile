FROM debian:bookworm

RUN cat /etc/apt/sources.list \
    && sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list \
    && sed -i "s/security.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list \
    && echo "\n" \
    && cat /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    # common
    vim procps git curl \
    # nginx build
    gcc make \
    # nginx
    libpcre3-dev openssl libssl-dev zlib1g-dev \
    # nginx-dav-ext-module
    libxslt1-dev \
    # auth basic
    apache2-utils

RUN cd /usr/local/src/ \
    && curl -LO https://nginx.org/download/nginx-1.22.1.tar.gz \
    && curl -L https://github.com/arut/nginx-dav-ext-module/archive/refs/tags/v3.0.0.tar.gz -o nginx-dav-ext-module-3.0.0.tar.gz \
    && tar -zxvf nginx-1.22.1.tar.gz \
    && tar -zxvf nginx-dav-ext-module-3.0.0.tar.gz

RUN groupadd nginx \
    && useradd nginx -g nginx -s /usr/sbin/nolgoin -M \
    && cd /usr/local/src/nginx-1.22.1\
    && ./configure \
    --prefix=/usr/local/nginx \
    --sbin-path=/usr/local/nginx/sbin/nginx \
    # --modules-path=/usr/local/nginx/lib/modules \
    --conf-path=/usr/local/nginx/conf/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    # --http-client-body-temp-path=/var/cache/nginx/client_temp \
    # --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    # --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    # --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    # --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-compat \
    --with-file-aio \
    --with-threads \
    --with-http_addition_module \
    --with-http_auth_request_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_mp4_module \
    --with-http_random_index_module \
    --with-http_realip_module \
    --with-http_secure_link_module \
    --with-http_slice_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_sub_module \
    --with-http_v2_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-stream \
    --with-stream_realip_module \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    # nginx-dav-ext-module
    --with-http_dav_module --add-module=/usr/local/src/nginx-dav-ext-module-3.0.0 \
    && make \
    && make install \
    && rm -rf /usr/local/src/*

ENV PATH="/usr/local/nginx/sbin:$PATH"

COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
