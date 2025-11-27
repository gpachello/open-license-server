#!/bin/sh
set -e

echo "[entrypoint] Preparando entorno..."

# 1. Crear base si no existe
if [ ! -f /db/license.db ]; then
    echo "[entrypoint] Creando base SQLite..."
    sqlite3 /db/license.db "VACUUM;"
fi

# 2. Restaurar último backup si existe
if [ -f /bup/backup.db ]; then
    echo "[entrypoint] Restaurando backup..."
    cp /bup/backup.db /db/license.db
fi

# 3. Otras tareas de inicialización
# ...

echo "[entrypoint] Servicio iniciado. Contenedor en espera."

# LAST. Mantener contenedor vivo
exec /bin/sh -c "tail -f /dev/null"
