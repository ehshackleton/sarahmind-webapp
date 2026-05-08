class ClinicalNotePolicy < ApplicationPolicy
  def create?
    user&.clinical_access? && patient_visible?
  end

  private

  def patient_visible?
    user.role_system_admin? || record.patient.professional_id == user.id
  end
end
