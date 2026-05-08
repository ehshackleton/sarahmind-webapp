module Portal
  class AuditEventsController < BaseController
    def index
      @audit_events = policy_scope(AuditEvent).order(created_at: :desc).limit(200)
      authorize AuditEvent
    end
  end
end
