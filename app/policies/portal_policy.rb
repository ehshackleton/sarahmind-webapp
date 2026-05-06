class PortalPolicy < ApplicationPolicy
  def dashboard?
    user.present?
  end
end
