# Auditoría y retención de datos

Este documento orienta la operación de SarahMind en torno al **registro de actividades sensibles** y a las **decisiones de conservación** de la información. Debe completarse con la política institucional y el marco legal aplicable (por ejemplo, normativa de salud y protección de datos en cada jurisdicción).

## Auditoría

- Los eventos registrados en `audit_events` cubren acciones como acceso a información clínica, cambios de rol, sesiones de usuario, agenda, notas internas y actualizaciones relevantes de fichas.
- La vista de auditoría está restringida a perfiles `system_admin` y muestra metadatos **resumidos y enmascarados** (por ejemplo, correos parcialmente ocultos) para reducir exposición en pantalla.
- Los metadatos no deben usarse para almacenar texto clínico ni datos innecesarios; preferir identificadores y nombres de campo.

## Retención (lineamientos)

- **Eventos de auditoría**: definir un plazo de conservación alineado al cumplimiento legal y clínico (p. ej. años mínimos exigidos). Valorar archivo frío o anonimización antes del borrado.
- **Datos clínicos y notas**: la retención debe seguir protocolos del servicio y consentimientos informados; no eliminar por software sin proceso revisado.
- **Usuarios y credenciales**: al dar de baja cuentas, acotar qué registros históricos se conservan vinculados a un identificador técnico anonimizado.
- **Backups**: las copias de seguridad heredan la misma clasificación de datos; el calendario de backups y restauraciones debe documentarse aparte.

## Próximos pasos técnicos sugeridos

- Tarea programada de purga o archivo de `audit_events` según política aprobada.
- Exportación firmada de auditoría para inspecciones.
- Registro de accesos a la propia vista de auditoría (meta-auditoría), si el riesgo lo exige.
