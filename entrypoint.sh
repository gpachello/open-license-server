#!/bin/sh
set -e

echo "[entrypoint] Preparando entorno..."

if [ ! -f /db/license.db ]; then
    echo "[entrypoint] Creando base SQLite..."
    sqlite3 /db/license.db "VACUUM;"
fi

if [ -f /bup/backup.db ]; then
    echo "[entrypoint] Restaurando backup..."
    cp /bup/backup.db /db/license.db
fi

echo "[entrypoint] Inicialización completa."
exec "$@"

