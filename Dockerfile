FROM nonedotone/caddy:v2.5.1

LABEL name="none" email="none@none.one"

ENV HUGO_VERSION=0.101.0

ADD hook-blog.sh /exec/

RUN apk add --no-cache bash upx libc6-compat libstdc++ git \
    && wget -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    && tar -xzf /tmp/hugo.tar.gz -C /tmp && mv /tmp/hugo /usr/bin/hugo \
    && upx /usr/bin/hugo && upx /usr/bin/caddy && chmod +x /exec/hook-blog.sh \
    && rm -f /tmp/hugo.tar.gz /tmp/LICENSE /tmp/README.md