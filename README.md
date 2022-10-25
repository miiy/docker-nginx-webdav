## Build

```bash
docker build -t webdav .
```

## Https

```bash
openssl genrsa -out config/nginx/certs/cert.key 4096

openssl req -sha512 -new \
-subj "/C=CN" \
-key config/nginx/certs/cert.key \
-out config/nginx/certs/cert.csr

openssl x509 -req  -days 3650 \
-in config/nginx/certs/cert.csr \
-signkey config/nginx/certs/cert.key \
-out config/nginx/certs/cert.crt
```

## Http basic auth

```bash
sudo docker run -it -v $(pwd)/config/nginx/:/usr/local/nginx/conf --rm webdav htpasswd -bc /usr/local/nginx/conf/htpasswd admin 123456
```

## Run

```bash
docker run --rm --name webdav -d \
    -p 8088:80 -p 4433:443 \
    -v $(pwd)/config/nginx/certs:/usr/local/nginx/conf/certs:ro \
    -v $(pwd)/config/nginx/nginx.conf:/usr/local/nginx/conf/nginx.conf:ro \
    -v $(pwd)/config/nginx/htpasswd:/usr/local/nginx/conf/htpasswd:ro \
    -v $(pwd)/www:/data/www/ \
    webdav:latest
```
