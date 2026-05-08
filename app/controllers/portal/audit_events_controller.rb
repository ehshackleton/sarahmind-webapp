module Portal
  class AuditEventsController < BaseController
    def index
      @audit_events = policy_scope(AuditEvent).order(created_at: :desc).limit(200)
      authorize AuditEvent
    end

    def retention_guide
      authorize AuditEvent, :retention_guide?

      path = Rails.root.join("docs/audit-and-data-retention.md")
      return head :not_found unless path.file?

      @doc_content = File.read(path, encoding: "UTF-8")
      render :retention_guide
    end
  end
end
