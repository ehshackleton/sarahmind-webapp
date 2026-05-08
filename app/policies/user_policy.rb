class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none unless user&.role_system_admin?

      scope.order(:email)
    end
  end

  def index?
    user&.role_system_admin?
  end

  def update?
    user&.role_system_admin?
  end
end
