class ClinicalNote < ApplicationRecord
  belongs_to :patient, inverse_of: :clinical_notes
  belongs_to :professional, class_name: "User", inverse_of: :clinical_notes

  validates :body, presence: true
end
