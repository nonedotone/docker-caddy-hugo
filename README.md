# docker-caddy-hugo

caddy with hugo(amd64)

## build

```bash
docker build --no-cache -t nonedotone/caddy-hugo https://github.com/nonedotone/docker-caddy-hugo.git
```

## config

config with Caddyfile

```Caddyfile
handle {
    root * /srv/public/blog
}
file_server

route /hook/blog {
    basicauth {
        hookblog JDJhJDE0JHJNSkMxQnd6endtQ1BvN100000000000000000000000000000000000000000000000000
    }
    exec bash /exec/hook-blog.sh {
        timeout 120s
    }
}
```

config with docker-compose

```yml
version: '3'
services:
  caddy:
    image: nonedotone/caddy-hugo
    container_name: caddy
    ports:
      - 80:80
      - 443:443
    environment:
      - REPOSITORY=https://github.com/nonedotone/example.git
    volumes:
...
```