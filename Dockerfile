FROM nonedotone/caddy:v2.5.2

LABEL name="none" email="none@none.one"

ENV HUGO_VERSION=0.101.0
ENV MDBOOK_VERSION=0.4.20

ADD hook-*.sh /exec/

RUN apk add --no-cache bash upx libc6-compat libstdc++ git \
    && wget -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    && wget -O /tmp/mdbook.tar.gz https://github.com/rust-lang/mdBook/releases/download/v${MDBOOK_VERSION}/mdbook-v${MDBOOK_VERSION}-x86_64-unknown-linux-gnu.tar.gz \
    && tar -xzf /tmp/hugo.tar.gz -C /tmp && mv /tmp/hugo /usr/bin/hugo \
    && tar -xzf /tmp/mdbook.tar.gz -C /tmp && mv /tmp/mdbook /usr/bin/mdbook \
    && upx /usr/bin/hugo && upx /usr/bin/caddy && chmod +x /exec/hook-*.sh \
    && rm -f /tmp/*.tar.gz /tmp/LICENSE /tmp/README.md