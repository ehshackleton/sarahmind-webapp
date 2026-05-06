# SarahMind WebApp

Base inicial de desarrollo para la plataforma `sarahmind.cl`, construida a partir del alcance definido en `literate.org`.

## Objetivo del repositorio

Implementar una webapp en Ruby on Rails con dos productos conectados:

- Sitio publico informativo y educativo.
- Portal privado para gestion clinica/operativa con control de acceso por roles.

## Alcance inicial (MVP)

- **MVP 1 (Publico):** Inicio, Quienes somos, Cursos, Tips y ejercicios, Noticias, Recursos de ayuda, Contacto, Login.
- **MVP 2 (Backoffice base):** Login seguro, roles, dashboard, gestion de pacientes, ficha protegida, adjuntos, notas internas, auditoria basica.

El detalle funcional y estrategico de largo plazo esta en `literate.org`.

## Estructura inicial

- `docs/architecture.md`: arquitectura tecnica, decisiones base y seguridad inicial.
- `docs/domain-model.md`: entidades principales y relaciones.
- `docs/mvp-backlog.md`: backlog priorizado para ejecucion por iteraciones.
- `Gemfile`, `Dockerfile`, `docker-compose.yml`: base para iniciar una app Rails en contenedor.

## Inicio rapido (Docker)

1. Construir imagen:

   `docker compose build`

2. Crear app Rails en el repo (primera vez):

   `docker compose run --rm web rails new . --force --database=postgresql --css=tailwind --javascript=esbuild`

3. Levantar servicios:

   `docker compose up`

4. Crear y migrar base de datos:

   `docker compose run --rm web bin/rails db:create db:migrate`

## Seguridad (linea base)

- Autenticacion con `devise`.
- Autorizacion por politicas con `pundit`.
- Auditoria de cambios y accesos con `paper_trail` y/o tabla de eventos propia.
- Separacion de datos administrativos vs clinicos.
- Evitar exponer datos clinicos en listados generales.

## Siguientes pasos recomendados

1. Inicializar la app Rails con los comandos del inicio rapido.
2. Implementar autenticacion + roles.
3. Crear modulo de pacientes con campos sensibles protegidos.
4. Agregar auditoria de lectura/edicion para ficha clinica.
