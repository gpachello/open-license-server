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
  ├── lic/
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

**4. Deberías ver el servicio opn-lic-srv ejecutándose:**
   ```bash
NAME                  IMAGE                           COMMAND                  SERVICE       CREATED          STATUS          PORTS
open-license-server   open-license-server:0.11.2025   "/usr/local/bin/entr…"   opn-lic-srv   16 seconds ago   Up 10 seconds   ```
  ```

**5. Ingresar al contenedor:**
   ```bash
   $ $ docker compose exec -it opn-lic-srv bash
   root@b488c2a55d3c:/lic# 
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

El directorio ```/lic``` es el workspace principal: ahí se guardan los certificados.  
El directorio ```/scp``` es para crear scripts, probar comandos y ejecutar aplicaciones Python que interactúen con open-license-server.

---

## 💾 Backups

El directorio ```/bup``` está destinado a almacenar backups de la base de datos.
El mecanismo de backup y restore se implementará junto con los scripts Python.

---

> [!NOTE]
> ## Permisos, bind mounts (UID/GID en host y contenedor)
> 
> Cuando se usan bind mounts (montar un directorio del host dentro del contenedor), Docker no cambia permisos ni propietarios: el contenedor ve exactamente el UID/GID del host.
> 
> Por este motivo, si dentro del contenedor se usa un usuario no-root (por ejemplo lic), es necesario que ese usuario tenga el mismo UID/GID en el host, o de lo contrario no podrá leer/escribir los directorios montados.
> 
> Esto no afecta a volúmenes de Docker, solo a bind mounts.

---

## Crear un usuario compatible en el host

Para evitar problemas de permisos, se recomienda crear un usuario en el host con el mismo UID/GID que el usuario interno del contenedor (lic).
El usuario no necesita home ni shell interactivo.

Ejemplo (con UID/GID 65432):

```bash
sudo groupadd -g 65432 lic
sudo useradd -u 65432 -g 65432 -M -s /sbin/nologin lic
```
Luego asignar los permisos correctos al proyecto:
```bash
sudo chown -R lic:lic open-license-server/
```
📌 Este procedimiento es opcional, pero necesario si querés que los scripts dentro del contenedor puedan leer/escribir sin problemas en los directorios montados del host.

---

## Crear el usuario dentro del contenedor (Dockerfile)

El contenedor define el mismo UID/GID:
```bash
RUN groupadd -r -g 65432 lic && \
    useradd -r -K UID_MAX=65535 -u 65432 -g 65432 -d /lic -s /bin/bash lic
```
El uso de ```-K UID_MAX=65535``` permite crear un usuario con UID por encima del límite por defecto (60000 en Debian), algo necesario si se prefiere usar rangos altos para evitar conflictos.

---

## 📌 ¿Por qué usar UID/GID altos?

Evita colisiones con usuarios reales del sistema (1000–60000).

Se alinea con el uso común en sistemas de virtualización (ej.: libvirt-qemu usa UIDs > 64000).

Facilita identificar usuarios creados “solo para permisos”.

Rangos recomendados para este tipo de contenedores: **64000–65535**

---

## 📌 Estado del proyecto

Proyecto en construcción.
Actualmente incluye:

* Infraestructura base (```Docker``` + ```debian:trixie-slim```)
* Estructura de CA Root (certs, private, crl, configuración)
* Sistema de directorios preparado para scripts
* Entrypoint funcional con manejo automático de permisos
* Integración lista para agregar SQLite + scripts Python

