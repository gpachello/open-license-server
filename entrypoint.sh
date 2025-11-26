#!/bin/sh
set -e

echo "[entrypoint] Creating directories..."
mkdir -p /ca /bup /scp

echo "[entrypoint] Fixing permissions..."
chown -R ca:ca /ca
chown -R ca:ca /bup
chown -R ca:ca /scp

echo "[entrypoint] Switching to user ca..."

# Ejecuta tail como usuario ca
exec su -s /bin/sh ca -c "tail -f /dev/null"
