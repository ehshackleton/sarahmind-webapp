# SarahMind WebApp

Aplicación Ruby on Rails para **SarahMind.cl**: sitio público informativo y portal privado (ver alcance en `literate.org` y `docs/mvp-backlog.md`).

## Requisitos

- Ruby **3.3.x** (ver [`.ruby-version`](.ruby-version); con **asdf**, en el directorio del repo: `asdf install` si falta la versión indicada)
- PostgreSQL **16+**
- Node.js **20+** y **npm** (assets: esbuild + Tailwind vía `package-lock.json`)

O bien solo **Docker** + Docker Compose.

## Configuración rápida (local, sin Docker)

```bash
cp .env.example .env
# Ajustar DATABASE_* si tu Postgres no usa usuario/clave por defecto

bundle install
npm ci   # o npm install
bin/rails db:create db:migrate db:seed
bin/dev  # Rails + esbuild + Tailwind en modo watch (ver Procfile.dev)
```

Abre `http://localhost:3000`. La raíz muestra una página de inicio base con layout y estilos alineados a la identidad sugerida.

### Autenticación y portal (Sprint 1)

- **Inicio de sesión:** `/users/sign_in` (registro público deshabilitado; usuarios creados por semillas o administración).
- **Portal privado:** `/portal` (requiere sesión). Tras `db:seed`, prueba con `paciente@sarahmind.test` / contraseña por defecto `Cambiala123!` (o `SEED_USER_PASSWORD` en `.env`).

## Docker (desarrollo)

```bash
docker compose build web
docker compose run --rm web bin/rails db:create db:migrate
docker compose up
```

Variables de base de datos para el servicio `web` están definidas en `docker-compose.yml` (`DATABASE_HOST=db`, etc.).

El servicio `web` monta un volumen dedicado para `node_modules`, así los binarios de **esbuild** y **Tailwind** corresponden a Linux dentro del contenedor (evita errores si en el Mac también tienes `npm install`).

Tras cambiar `Gemfile` o `Gemfile.lock`, vuelve a construir la imagen: `docker compose build web`.

## Validación local (checklist)

**Opción A — Docker (recomendada)**

1. `docker compose build web`
2. `docker compose run --rm web bin/rails db:create db:migrate`
3. `docker compose up` y comprobar en el navegador `http://localhost:3000` y `http://localhost:3000/up` (200).
4. En contenedor: `docker compose run --rm web bin/rails test`, `bin/rubocop`, `bin/brakeman --no-pager`.

**Opción B — Host (Ruby 3.3 + Postgres + Node 20)**

1. `.env` desde `.env.example`, `bundle install`, `npm ci`.
2. `bin/rails db:create db:migrate` (y opcional `db:seed`).
3. `bin/dev` o solo `bin/rails server` (si ya compilaste assets con `npm run build` y `npm run build:css`).
4. Mismas URLs y mismos comandos de test/lint/seguridad que en CI: `bin/rails test`, `bin/rubocop`, `bin/brakeman --no-pager`.

## Entornos

- **development / test:** conexión PostgreSQL vía `config/database.yml` y variables `DATABASE_*` (o `DATABASE_URL` en CI).
- **production:** usar `DATABASE_NAME`, `DATABASE_USER`, `DATABASE_PASSWORD` y `SECRET_KEY_BASE` según tu despliegue; las credenciales sensibles deben venir desde variables de entorno o tu proveedor de secretos.

## CI

GitHub Actions (`.github/workflows/ci.yml`): Brakeman, RuboCop (omakase), tests con Postgres y build de la imagen Docker de producción.

## Producción en Azure VM

El despliegue pensado para este repo usa:

- una VM con Docker y Docker Compose
- Traefik ya corriendo en la misma máquina
- la red Docker externa `proxy`
- el workflow manual `.github/workflows/deploy.yml`

### Preparación en la VM

1. Crear la red si aún no existe: `docker network create proxy`
2. Clonar el repo en la VM o dejar que lo haga el workflow
3. Copiar `.env.production.example` a `.env.production`
4. Completar secretos reales en `.env.production`

El archivo `docker-compose.production.yml` levanta:

- `db` con volumen persistente para PostgreSQL
- `web` con volumen persistente para `storage`
- labels de Traefik para publicar `APP_HOST` por HTTPS

### Secrets y variables en GitHub

Secrets del repositorio:

- `SSH_HOST`
- `SSH_USER`
- `SSH_PRIVATE_KEY`

Variables opcionales del repositorio:

- `SSH_PORT` (por defecto `22`)
- `DEPLOY_ROOT` (por defecto `/home/azureuser/sarahmind-webapp`)
- `DEPLOY_BRANCH` (por defecto `main`)
- `REPO_URL` (por defecto el repositorio actual en GitHub)

### Despliegue

Una vez configurada la VM y los secrets, ejecuta manualmente el workflow `Deploy production (Azure VM)` desde GitHub Actions. El job:

1. valida secretos SSH
2. conecta por SSH a la VM
3. sincroniza la rama de despliegue
4. exige que exista `.env.production`
5. ejecuta `docker compose -f docker-compose.production.yml --env-file .env.production build`
6. ejecuta `docker compose -f docker-compose.production.yml --env-file .env.production up -d --remove-orphans`

## Documentación del proyecto

- `docs/architecture.md` — arquitectura y seguridad base
- `docs/domain-model.md` — modelo de dominio inicial
- `docs/mvp-backlog.md` — backlog por sprints
- [`docs/audit-and-data-retention.md`](docs/audit-and-data-retention.md) — auditoría, metadatos y lineamientos de retención de datos (en el **portal**, usuario `system_admin`: **Auditoría** → *Guía de auditoría y retención*, ruta interna que muestra el mismo archivo)

## Imagen de producción

El `Dockerfile` en la raíz es el generado por Rails para despliegue (p. ej. Kamal). Para desarrollo día a día se usa `Dockerfile.dev` con `docker compose`.
