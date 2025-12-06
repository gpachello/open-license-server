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

>[!NOTE]
> ## ⚠️ Prerequisito importante (antes del build)
> Este proyecto usa un contenedor **rootless**, es decir: el servicio corre con un usuario interno (`lic`) que no es root y tiene un **UID/GID fijo 65432**.  
>
> Cuando se usan **bind mounts**, Docker mantiene los permisos del host.
Por lo tanto:
>
> **👉 Si no existe en el host un usuario con el mismo UID/GID, el contenedor NO podrá escribir en los directorios montados.**
> 
> **✔️ Crear el usuario en el host**
> ```bash
> sudo groupadd -g 65432 lic
> sudo useradd -u 65432 -g 65432 -M -s /sbin/nologin lic
> ```
> Dar permisos al proyecto:
> ```bash
> sudo chown -R lic:lic open-license-server/
> ```
> 📌 Si usás solo volúmenes de Docker, esto no es necesario.  
> 📌 Si usás bind mounts (como hace este proyecto), sí es necesario ANTES del build.
>
> ---
>
> **👤 Usuario dentro del contenedor**  
> Dockerfile crea un usuario con el mismo UID/GID:
> ```bash
> RUN groupadd -r -g 65432 lic && \
>     useradd -r -K UID_MAX=65535 -u 65432 -g 65432 -d /lic -s /bin/bash lic
> ```

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

**2. (Si no lo hiciste previamente) Crear el usuario del host y asignar permisos**  
📌 Necesario antes del build si usás bind mounts.

**3. Construir y levantar el servicio**  
```bash
docker compose up -d --build
```

**4. Verificar ejecución**
```bash
docker compose ps
```

**Deberías ver el servicio opn-lic-srv ejecutándose**
```bash
NAME                  IMAGE                           COMMAND                  SERVICE       CREATED             STATUS             PORTS
open-license-server   open-license-server:0.11.2025   "/usr/local/bin/entr…"   opn-lic-srv   About an hour ago   Up About an hour   0.0.0.0:8000->8000/tcp
```

**5. Ingresar al contenedor:**
```bash
docker compose exec -it opn-lic-srv bash
```

---

## 📂 Espacio de trabajo

* `/lic` → CA Root (certificados, claves, CRLs)
* `/scp` → scripts auxiliares y utilidades Python
* `/bup` → backups de la base
* `/db`  → se crea automáticamente

---

## 📌 Estado del proyecto (en desarrollo)

Actualmente incluye:  

* **Infraestructura base:** Docker + Debian Trixie Slim + Python
* **Criptografía:** OpenSSL + `python3-cryptography`
* **Frontend API:** FastAPI + Uvicorn
* **Estructura prevista:** licencias, backups, scripts y base de datos
* **Entrypoint funcional:** inicialización automática + permisos + verificación de entorno
* **Persistencia:** integración prevista para SQLite y lógica de licenciamiento
