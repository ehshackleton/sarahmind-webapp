module Portal
  # Agrega las consultas del panel en un solo lugar para mantener el controlador delgado
  # y alinear métricas con el alcance Pundit del usuario.
  class DashboardMetrics
    def initialize(patient_scope:, session_scope:)
      @patient_scope = patient_scope
      @session_scope = session_scope
    end

    def to_h
      {
        total_patients: @patient_scope.count,
        active_patients: @patient_scope.where(status: "active").count,
        new_patients_month: @patient_scope.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).count,
        clinical_notes: ClinicalNote.joins(:patient).merge(@patient_scope).count,
        documents_attached: @patient_scope.joins(:documents_attachments).distinct.count,
        upcoming_sessions: @session_scope.merge(TherapySession.upcoming).count,
        sessions_today: today_scheduled_sessions.count
      }
    end

    def upcoming_sessions(limit: 8)
      @session_scope.merge(TherapySession.upcoming).includes(:patient, :professional).limit(limit)
    end

    def today_scheduled_sessions
      @session_scope
        .status_scheduled
        .where(starts_at: Time.zone.today.all_day)
        .includes(:patient, :professional)
        .order(starts_at: :asc)
    end
  end
end
