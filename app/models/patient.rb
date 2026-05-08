class Patient < ApplicationRecord
  STATUSES = %w[active paused closed].freeze

  belongs_to :professional, class_name: "User", optional: true, inverse_of: :assigned_patients
  has_many :clinical_notes, dependent: :destroy, inverse_of: :patient
  has_many :therapy_sessions, dependent: :destroy, inverse_of: :patient
  has_many_attached :documents

  validates :full_name, presence: true
  validates :status, inclusion: { in: STATUSES }
end
