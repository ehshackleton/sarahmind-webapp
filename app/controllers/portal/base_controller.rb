module Portal
  class BaseController < ApplicationController
    before_action :authenticate_user!

    private

    def log_audit!(action, auditable: nil, metadata: {})
      AuditLogger.log!(
        actor: current_user,
        action: action,
        auditable: auditable,
        metadata: metadata,
        request: request
      )
    end
  end
end
