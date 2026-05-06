# Backlog MVP inicial

## Sprint 0 - Fundaciones tecnicas

- [ ] Inicializar app Rails con PostgreSQL.
- [ ] Configurar entornos (`development`, `test`, `production`).
- [ ] Integrar Tailwind + layout base.
- [ ] Configurar CI minima (tests + lint).
- [ ] Definir variables de entorno y credenciales.

## Sprint 1 - Seguridad y acceso

- [ ] Implementar `devise` para autenticacion.
- [ ] Implementar roles (`system_admin`, `admin`, `professional`, `patient`).
- [ ] Integrar `pundit` para autorizacion.
- [ ] Crear semilla de usuarios por rol.
- [ ] Bloquear rutas privadas para usuarios no autenticados.

## Sprint 2 - Sitio publico (MVP 1)

- [ ] Home con hero, bloque de seguridad y recursos principales.
- [ ] Pagina "Quienes somos".
- [ ] Catalogo basico de cursos.
- [ ] Seccion de tips y ejercicios.
- [ ] Seccion de noticias y recursos.
- [ ] Pagina de contacto.

## Sprint 3 - Backoffice base (MVP 2)

- [ ] Dashboard con metricas iniciales.
- [ ] CRUD de pacientes.
- [ ] Vista de ficha paciente con seccion clinica protegida.
- [ ] Adjuntar documentos con Active Storage.
- [ ] Notas internas por profesional.

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
