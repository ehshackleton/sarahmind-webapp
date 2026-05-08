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
- **production:** usar `DATABASE_NAME`, `DATABASE_USER` y `APP_DATABASE_PASSWORD` (o `DATABASE_PASSWORD`) según tu despliegue; credenciales sensibles en el proveedor o `RAILS_MASTER_KEY` + credentials.

## CI

GitHub Actions (`.github/workflows/ci.yml`): Brakeman, RuboCop (omakase) y tests con Postgres.

## Documentación del proyecto

- `docs/architecture.md` — arquitectura y seguridad base
- `docs/domain-model.md` — modelo de dominio inicial
- `docs/mvp-backlog.md` — backlog por sprints
- [`docs/audit-and-data-retention.md`](docs/audit-and-data-retention.md) — auditoría, metadatos y lineamientos de retención de datos (en el **portal**, usuario `system_admin`: **Auditoría** → *Guía de auditoría y retención*, ruta interna que muestra el mismo archivo)

## Imagen de producción

El `Dockerfile` en la raíz es el generado por Rails para despliegue (p. ej. Kamal). Para desarrollo día a día se usa `Dockerfile.dev` con `docker compose`.
