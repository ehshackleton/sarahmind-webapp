# Modelo de dominio inicial

## Entidades nucleares

- `User`
  - email, encrypted_password, role, status
  - Asociaciones: `patient_profile`, `professional_profile`

- `PatientProfile`
  - user_id, full_name, document_id, birth_date, phone, emergency_contact
  - Asociaciones: clinical_records, care_plans, sessions, attachments

- `ProfessionalProfile`
  - user_id, specialty, license_number
  - Asociaciones: assigned_patients, sessions

- `ClinicalRecord`
  - patient_profile_id, summary, sensitive_notes_encrypted
  - Asociaciones: clinical_notes, attachments

- `ClinicalNote`
  - clinical_record_id, professional_profile_id, body_encrypted

- `CarePlan`
  - patient_profile_id, objective, current_stage, risk_level
  - Asociaciones: patient_goals, assigned_exercises

- `Session`
  - patient_profile_id, professional_profile_id, starts_at, ends_at, status, meet_url
  - Asociaciones: followup_note

- `Course`
  - title, description, level, duration_minutes, published
  - Asociaciones: course_modules, enrollments

- `CourseModule`
  - course_id, title, position
  - Asociaciones: lessons

- `Lesson`
  - course_module_id, title, content, position

- `Exercise`
  - title, category, instructions, disclaimer

- `Enrollment`
  - course_id, user_id, enrolled_at, status

- `Progress`
  - enrollment_id, lesson_id, completed_at, score

- `NewsArticle`
  - title, body, source_url, published_at, category

- `Payment`
  - user_id, service_id, amount_cents, status, paid_at, payment_method

- `Invoice`
  - payment_id, document_number, issued_at, external_reference

- `AuditEvent`
  - actor_id, action, auditable_type, auditable_id, metadata, created_at

## Relaciones clave

- Un `User` puede ser paciente o profesional segun su `role`.
- Un `PatientProfile` puede tener multiples sesiones, notas y planes.
- Un `ProfessionalProfile` atiende multiples pacientes.
- Un `Course` contiene multiples modulos y lecciones.
- Un `Enrollment` conecta usuario y curso; `Progress` guarda avance granular.

## Reglas de dominio prioritarias

- Una sesion debe tener profesional y paciente asignados.
- Los enlaces Meet son unicos por sesion.
- Solo roles autorizados pueden leer/escribir contenido clinico.
- Cada acceso a ficha clinica genera `AuditEvent`.
