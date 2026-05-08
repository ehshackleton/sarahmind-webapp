module Portal
  class DashboardController < BaseController
    def show
      authorize :portal, :dashboard?

      scoped_patients = policy_scope(Patient)
      scoped_sessions = policy_scope(TherapySession)
      snapshot = Portal::DashboardMetrics.new(patient_scope: scoped_patients, session_scope: scoped_sessions)
      @metrics = snapshot.to_h
      @upcoming_sessions = snapshot.upcoming_sessions
      @sessions_today = snapshot.today_scheduled_sessions
    end
  end
end
