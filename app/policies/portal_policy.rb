class PortalPolicy < ApplicationPolicy
  def dashboard?
    user&.backoffice_role?
  end
end
