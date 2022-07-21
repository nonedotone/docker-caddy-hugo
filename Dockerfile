FROM alpine AS builder

ARG MDBOOK_VERSION=0.4.20
ENV HUGO_VERSION=0.101.0

RUN apk add --no-cache upx cargo && \
    wget -O /tmp/mdbook.tar.gz "https://github.com/rust-lang/mdBook/archive/v$MDBOOK_VERSION.tar.gz" && \
    cd /tmp && tar -xzvf mdbook.tar.gz && cd /tmp/mdBook* && cargo build --release && \
    mv /tmp/mdBook*/target/release/mdbook /tmp/mdbook && \
    wget -O /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    tar -xzf /tmp/hugo.tar.gz -C /tmp && chmod +x /tmp/hugo && upx /tmp/hugo



FROM nonedotone/caddy:v2.5.2
LABEL name="none" email="none@none.one"

ADD hook-*.sh /exec/

RUN apk add --no-cache bash jq libc6-compat libstdc++ git && \
    chmod +x /exec/hook-*.sh

COPY --from=builder /tmp/mdbook /usr/bin/mdbook
COPY --from=builder /tmp/mdbook /usr/bin/hugo