# open-license-server
Servidor de licencias de uso personal basado en tecnologías **Open Source**.  
Incluye la infraestructura necesaria para mantener una **CA Root**, manejar certificados y preparar un sistema de licencias firmado digitalmente.

Este proyecto está pensado para ser **portable, sencillo y fácil de extender**.

---

## 🚀 Objetivos del proyecto

* Construir una **CA Root** local dentro de un entorno reproducible.
* Mantener un sistema de directorio para certificados, claves privadas y CRLs.
* Preparar el entorno para gestionar clientes, certificados y licencias mediante scripts **Python + SQLite**.
* Proveer un contenedor Docker minimalista, rápido de iniciar y fácil de respaldar.
* Permitir auditoría sencilla de la base mediante **backups regulares**.

---

## 📂 Estructura del proyecto

```bash
open-license-server/
  ├── Dockerfile
  ├── docker-compose.yml
  ├── entrypoint.sh
  ├── ca/
  │   ├── certs/
  │   ├── private/
  │   ├── crl/
  │   └── openssl.cnf
  ├── scp/
  ├── bup/
  └── db/                     (creado dentro del contenedor)
```

---

## 🐳 Uso

**1. Clonar el repositorio:**
   ```bash
   git clone https://github.com/gpachello/open-license-server.git
   cd open-license-server
   ```

**2. Construir y levantar el servicio**

```bash
docker compose up -d --build
```

El contenedor se inicia, ajusta permisos de directorios y queda ejecutándose.

**3. Verificá el estado:**
   ```bash
   docker compose ps
   ```

**4. Deberías ver el servici opn-lic-srv ejecutándose:**
   ```bash
NAME                  IMAGE                           COMMAND                  SERVICE       CREATED          STATUS          PORTS
open-license-server   open-license-server:0.11.2025   "/usr/local/bin/entr…"   opn-lic-srv   16 seconds ago   Up 10 seconds   ```
  ```

**5. Ingresar al contenedor:**
   ```bash
   $ $ docker compose exec -u ca -it opn-lic-srv bash
   root@b488c2a55d3c:/ca# 
   ```
**6. Próximos pasos (en desarrollo)**

Los scripts para:

* inicializar la base SQLite
* gestionar clientes
* emitir certificados
* generar licencias firmadas

... se agregarán próximamente.

---

## 📂 Espacio de trabajo

El directorio ```/ca``` es el workspace principal: ahí se pueden crear scripts, probar comandos y ejecutar aplicaciones Python que interactúen con open-license-server.

---

## 💾 Backups

El directorio ```/bup``` está destinado a almacenar backups de la base de datos.
El mecanismo de backup y restore se implementará junto con los scripts Python.

---

## 📌 Estado del proyecto

Proyecto en construcción.
Actualmente incluye:

* Infraestructura base (```Docker``` + ```debian:trixie-slim```)
* Estructura de CA Root (certs, private, crl, configuración)
* Sistema de directorios preparado para scripts
* Entrypoint funcional con manejo automático de permisos
* Integración lista para agregar SQLite + scripts Python

