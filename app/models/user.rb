class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  enum :role, {
    patient: "patient",
    professional: "professional",
    admin: "admin",
    system_admin: "system_admin"
  }, prefix: true

  validates :role, inclusion: { in: roles.keys.map(&:to_s) }
end
