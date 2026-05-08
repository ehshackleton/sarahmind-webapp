# Backlog MVP inicial

## Sprint 0 - Fundaciones tecnicas

- [x] Inicializar app Rails con PostgreSQL.
- [x] Configurar entornos (`development`, `test`, `production`).
- [x] Integrar Tailwind + layout base.
- [x] Configurar CI minima (tests + lint).
- [x] Definir variables de entorno y credenciales.

## Sprint 1 - Seguridad y acceso

- [x] Implementar `devise` para autenticacion.
- [x] Implementar roles (`system_admin`, `admin`, `professional`, `patient`).
- [x] Integrar `pundit` para autorizacion.
- [x] Crear semilla de usuarios por rol.
- [x] Bloquear rutas privadas para usuarios no autenticados.

## Sprint 2 - Sitio publico (MVP 1)

- [x] Home con hero, bloque de seguridad y recursos principales.
- [x] Pagina "Quienes somos".
- [x] Catalogo basico de cursos.
- [x] Seccion de tips y ejercicios.
- [x] Seccion de noticias y recursos.
- [x] Pagina de contacto.

## Sprint 3 - Backoffice base (MVP 2)

- [x] Dashboard con metricas iniciales.
- [x] CRUD de pacientes.
- [x] Vista de ficha paciente con seccion clinica protegida.
- [x] Adjuntar documentos con Active Storage.
- [x] Notas internas por profesional.

## Sprint 4 - Auditoria y trazabilidad

- [ ] Registrar inicio/cierre de sesion.
- [ ] Auditar lectura y edicion de ficha clinica.
- [ ] Auditar descargas de documentos.
- [ ] Auditar cambios de rol.
- [ ] Vista de auditoria para `system_admin`.

## Sprint 5 - Agenda base

- [ ] CRUD de sesiones.
- [ ] Estados de sesion (programada, realizada, cancelada).
- [ ] Notificacion por correo al paciente.
- [ ] Integracion inicial con Google Calendar.

## Criterios de aceptacion transversales

- Politicas de autorizacion cubren todos los recursos privados.
- Campos sensibles no aparecen en listados generales.
- Eventos criticos quedan trazados en auditoria.
- Cobertura minima de tests para dominios sensibles.
