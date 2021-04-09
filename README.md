## Build

docker build -t webdav .

## Https

```bash
openssl genrsa -out cert.key 4096

openssl req -sha512 -new \
-subj "/C=CN" \
-key cert.key \
-out cert.csr

openssl x509 -req  -days 3650 \
-in cert.csr \
-signkey cert.key \
-out cert.crt
```

## Http basic auth

```bash
htpasswd -bc ./config/nginx/htpasswd admin 123456
```

## Run

```bash
docker run --rm --name webdav -d \
    -p 80:80 -p 443:443 \
    -v  $(pwd)/config/nginx/certs:/usr/local/nginx/conf/certs:ro \
    -v  $(pwd)/config/nginx/nginx.conf:/usr/local/nginx/conf/nginx.conf:ro \
    -v  $(pwd)/config/nginx/htpasswd:/usr/local/nginx/conf/htpasswd:ro \
    -v  $(pwd)/www:/data/www/ \
    webdav:latest
```
