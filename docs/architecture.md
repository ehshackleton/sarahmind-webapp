# Arquitectura tecnica inicial

## Stack base propuesto

- Ruby on Rails
- PostgreSQL
- Hotwire (Turbo + Stimulus)
- Tailwind CSS
- Active Storage
- Action Mailer
- Background jobs (Solid Queue o Sidekiq)

## Modulos funcionales (por capas)

- **Publico:** paginas institucionales, cursos, tips, noticias, recursos.
- **Identidad y acceso:** login, recuperacion, roles y permisos.
- **Backoffice:** dashboard, pacientes, ficha, agenda, contenidos.
- **Administracion:** ventas, pagos, boletas, reportes.
- **Integraciones:** Google Calendar, Google Meet, correo saliente.
- **Trazabilidad y cumplimiento:** auditoria de accesos y cambios sensibles.

## Principios de diseno

- Seguridad por defecto.
- Minimo privilegio por rol.
- Separacion explicita de informacion clinica y administrativa.
- Trazabilidad de operaciones criticas.
- Despliegue incremental por MVP.

## Roles iniciales

- `system_admin`: control total de configuracion y seguridad.
- `admin`: gestion operativa.
- `professional`: gestion clinica de pacientes asignados.
- `patient`: acceso acotado a su informacion y recursos.

## Seguridad y privacidad (baseline implementable)

- Autenticacion obligatoria para todo backoffice.
- Politicas de autorizacion por recurso (Pundit).
- Soft-delete para evitar perdida accidental de registros.
- Cifrado de campos sensibles (ficha clinica, observaciones).
- Registro de auditoria para:
  - inicio de sesion,
  - lectura/edicion de ficha clinica,
  - descarga de documentos,
  - cambios de rol,
  - creacion/cancelacion de sesiones.

## Integraciones externas por fase

1. **Fase 1:** correo transaccional (notificaciones basicas).
2. **Fase 2:** Google Calendar + creacion de eventos.
3. **Fase 3:** Google Meet + link unico por sesion.
4. **Fase 4:** boleta/facturacion electronica segun proveedor definido.

## Convenciones recomendadas

- Namespaces por dominio: `Public::`, `Backoffice::`, `Admin::`.
- Servicio por integracion en `app/services`.
- Politicas de autorizacion en `app/policies`.
- Auditoria centralizada via callback + servicio `Audit::EventRecorder`.
