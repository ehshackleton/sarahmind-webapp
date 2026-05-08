module Portal
  class DashboardController < BaseController
    def show
      authorize :portal, :dashboard?

      scoped_patients = policy_scope(Patient)
      scoped_sessions = policy_scope(TherapySession)
      @metrics = {
        total_patients: scoped_patients.count,
        active_patients: scoped_patients.where(status: "active").count,
        new_patients_month: scoped_patients.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count,
        clinical_notes: ClinicalNote.joins(:patient).merge(scoped_patients).count,
        documents_attached: scoped_patients.joins(:documents_attachments).distinct.count,
        upcoming_sessions: scoped_sessions.status_scheduled.where("starts_at >= ?", Time.zone.now).count
      }
    end
  end
end
