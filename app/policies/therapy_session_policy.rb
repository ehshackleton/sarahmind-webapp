class TherapySessionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none unless user&.backoffice_role?
      return scope.all if user.role_system_admin? || user.role_admin?

      scope.left_joins(:patient).where(
        "therapy_sessions.professional_id = :uid OR patients.professional_id = :uid",
        uid: user.id
      ).distinct
    end
  end

  def index?
    user&.backoffice_role?
  end

  def show?
    user&.backoffice_role? && record_in_scope?
  end

  def create?
    return false unless user&.backoffice_role?
    return true if record.patient_id.blank?

    PatientPolicy.new(user, Patient.find(record.patient_id)).show?
  rescue ActiveRecord::RecordNotFound
    false
  end

  def update?
    user&.backoffice_role? && record_in_scope?
  end

  def destroy?
    user&.backoffice_role? && record_in_scope?
  end

  private

  def record_in_scope?
    return true if user.role_system_admin? || user.role_admin?

    record.professional_id == user.id || record.patient.professional_id == user.id
  end
end
