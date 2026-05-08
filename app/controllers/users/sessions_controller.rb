module Users
  class SessionsController < Devise::SessionsController
    def create
      super do |resource|
        AuditLogger.log!(
          actor: resource,
          action: "session.sign_in",
          auditable: resource,
          metadata: { email: resource.email },
          request: request
        )
      end
    end

    def destroy
      user = current_user
      AuditLogger.log!(
        actor: user,
        action: "session.sign_out",
        auditable: user,
        metadata: { email: user&.email },
        request: request
      ) if user.present?

      super
    end
  end
end
