class PatientPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none unless user&.backoffice_role?
      return scope.all if user.role_system_admin? || user.role_admin?

      scope.where(professional_id: user.id)
    end
  end

  def index?
    user&.backoffice_role?
  end

  def show?
    user&.backoffice_role? && visible_to_user?
  end

  def create?
    user&.role_system_admin? || user&.role_admin?
  end

  def update?
    user&.backoffice_role? && visible_to_user?
  end

  def destroy?
    user&.role_system_admin? || user&.role_admin?
  end

  def clinical_section?
    user&.clinical_access? && visible_to_user?
  end

  private

  def visible_to_user?
    user.role_system_admin? || user.role_admin? || record.professional_id == user.id
  end
end
