class ArticlePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none unless user&.backoffice_role?
      return scope.all if user.role_system_admin? || user.role_admin?

      scope.where(author_id: user.id)
    end
  end

  def index?
    user&.backoffice_role?
  end

  def show?
    manager_or_owner?
  end

  def create?
    user&.backoffice_role?
  end

  def update?
    manager_or_owner?
  end

  def destroy?
    manager_or_owner?
  end

  private

  def manager_or_owner?
    return false unless user&.backoffice_role?
    return true if user.role_system_admin? || user.role_admin?

    record.author_id == user.id
  end
end
