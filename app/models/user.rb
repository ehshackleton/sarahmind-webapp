class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  enum :role, {
    patient: "patient",
    professional: "professional",
    admin: "admin",
    system_admin: "system_admin"
  }, prefix: true

  validates :role, inclusion: { in: roles.keys.map(&:to_s) }

  has_many :assigned_patients,
           class_name: "Patient",
           foreign_key: :professional_id,
           inverse_of: :professional,
           dependent: :nullify
  has_many :clinical_notes, foreign_key: :professional_id, inverse_of: :professional, dependent: :nullify
  has_many :led_therapy_sessions,
           class_name: "TherapySession",
           foreign_key: :professional_id,
           inverse_of: :professional,
           dependent: :restrict_with_exception
  has_many :audit_events, foreign_key: :actor_id, inverse_of: :actor, dependent: :nullify

  def backoffice_role?
    role_system_admin? || role_admin? || role_professional?
  end

  def clinical_access?
    role_system_admin? || role_professional?
  end
end
