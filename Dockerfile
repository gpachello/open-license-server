FROM debian:trixie-slim

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        openssl \
        python3 \
        sqlite3 \
        sqlite3-tools \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r ca && useradd -r -g ca -d /ca -s /bin/sh ca

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

WORKDIR /ca
