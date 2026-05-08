class AuditEventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none unless user&.role_system_admin?

      scope.all
    end
  end

  def index?
    user&.role_system_admin?
  end
end
