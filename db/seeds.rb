# Semillas idempotentes: un usuario por rol para desarrollo y pruebas manuales.
password = ENV.fetch("SEED_USER_PASSWORD", "Cambiala123!")

seed_users = [
  { email: "system.admin@sarahmind.test", role: :system_admin },
  { email: "admin@sarahmind.test", role: :admin },
  { email: "pro@sarahmind.test", role: :professional },
  { email: "paciente@sarahmind.test", role: :patient }
]

seed_users.each do |attrs|
  user = User.find_or_initialize_by(email: attrs[:email])
  user.role = attrs[:role]
  user.password = password
  user.password_confirmation = password
  user.save!
end

Rails.logger.info { "Semillas de usuarios listas (contraseña por defecto en desarrollo: revisa SEED_USER_PASSWORD / .env)." }
