FROM debian:trixie-slim

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        openssl \
        python3 \
        sqlite3 \
        sqlite3-tools \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r lic && useradd -r -g lic -d /lic -s /bin/bash lic

# Crear directorios y cambiar propietario
RUN mkdir -p /lic /bup /scp /db && \
    chown -R lic:lic /lic /bup /scp /db

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER lic
WORKDIR /lic

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
