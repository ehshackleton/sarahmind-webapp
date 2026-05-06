# SarahMind WebApp

Aplicación Ruby on Rails para **SarahMind.cl**: sitio público informativo y portal privado (ver alcance en `literate.org` y `docs/mvp-backlog.md`).

## Requisitos

- Ruby **3.3.11** (ver `.ruby-version`)
- PostgreSQL **16+**
- Node.js **20+** y **Yarn** (assets: esbuild + Tailwind)

O bien solo **Docker** + Docker Compose.

## Configuración rápida (local)

```bash
cp .env.example .env
# Ajustar DATABASE_* si tu Postgres no usa usuario/clave por defecto

bundle install
yarn install
bin/rails db:create db:migrate
bin/dev
```

Abre `http://localhost:3000`. La raíz muestra una página de inicio base con layout y estilos alineados a la identidad sugerida.

## Docker (desarrollo)

```bash
docker compose build
docker compose run --rm web bin/rails db:create db:migrate
docker compose up
```

Variables de base de datos para el servicio `web` están definidas en `docker-compose.yml` (`DATABASE_HOST=db`, etc.).

El servicio `web` monta un volumen dedicado para `node_modules`, así los binarios de **esbuild** y **Tailwind** corresponden a Linux dentro del contenedor (evita errores si en el Mac también tienes `npm install`).

Tras cambiar `Gemfile` o `Gemfile.lock`, vuelve a construir la imagen: `docker compose build web`.

## Entornos

- **development / test:** conexión PostgreSQL vía `config/database.yml` y variables `DATABASE_*` (o `DATABASE_URL` en CI).
- **production:** usar `DATABASE_NAME`, `DATABASE_USER` y `APP_DATABASE_PASSWORD` (o `DATABASE_PASSWORD`) según tu despliegue; credenciales sensibles en el proveedor o `RAILS_MASTER_KEY` + credentials.

## CI

GitHub Actions (`.github/workflows/ci.yml`): Brakeman, RuboCop (omakase) y tests con Postgres.

## Documentación del proyecto

- `docs/architecture.md` — arquitectura y seguridad base
- `docs/domain-model.md` — modelo de dominio inicial
- `docs/mvp-backlog.md` — backlog por sprints

## Imagen de producción

El `Dockerfile` en la raíz es el generado por Rails para despliegue (p. ej. Kamal). Para desarrollo día a día se usa `Dockerfile.dev` con `docker compose`.
