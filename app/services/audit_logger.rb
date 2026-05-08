class AuditLogger
  def self.log!(actor:, action:, auditable: nil, metadata: {}, request: nil)
    AuditEvent.create!(
      actor: actor,
      action: action,
      auditable: auditable,
      metadata: metadata,
      ip_address: request&.remote_ip,
      user_agent: request&.user_agent
    )
  end
end
