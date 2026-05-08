module Portal
  class TherapySessionsController < BaseController
    before_action :set_therapy_session, only: %i[show edit update destroy]
    before_action :set_form_collections, only: %i[new edit create update]

    def index
      @therapy_sessions = policy_scope(TherapySession).includes(:patient, :professional).order(starts_at: :desc)
      authorize TherapySession
    end

    def show
      authorize @therapy_session
    end

    def new
      @therapy_session = TherapySession.new(new_session_attributes)
      authorize @therapy_session
    end

    def create
      @therapy_session = TherapySession.new(therapy_session_params)
      authorize @therapy_session

      if @therapy_session.save
        log_audit!("therapy_session.create", auditable: @therapy_session)
        redirect_to portal_therapy_session_path(@therapy_session), notice: "Sesión creada correctamente."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
      authorize @therapy_session
    end

    def update
      authorize @therapy_session

      if @therapy_session.update(therapy_session_params)
        meta = {}
        meta[:status] = @therapy_session.status if @therapy_session.saved_change_to_status?
        meta[:starts_at] = @therapy_session.starts_at.iso8601 if @therapy_session.saved_change_to_starts_at?
        log_audit!("therapy_session.update", auditable: @therapy_session, metadata: meta)
        redirect_to portal_therapy_session_path(@therapy_session), notice: "Sesión actualizada."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize @therapy_session
      patient = @therapy_session.patient
      session_id = @therapy_session.id
      @therapy_session.destroy
      log_audit!(
        "therapy_session.destroy",
        auditable: patient,
        metadata: { therapy_session_id: session_id }
      )
      redirect_to portal_therapy_sessions_path, notice: "Sesión eliminada."
    end

    private

    def set_therapy_session
      @therapy_session = policy_scope(TherapySession).find(params[:id])
    end

    def set_form_collections
      @patients = policy_scope(Patient).order(:full_name)
      @professionals = User.where(role: %i[professional system_admin]).order(:email)
    end

    def new_session_attributes
      starts = 1.day.from_now.change(hour: 10, min: 0, sec: 0)
      starts += 1.day if starts <= Time.zone.now

      {
        patient_id: params[:patient_id].presence,
        professional_id: current_user.role_professional? ? current_user.id : nil,
        starts_at: starts,
        ends_at: starts + 50.minutes,
        status: :scheduled
      }
    end

    def therapy_session_params
      params.require(:therapy_session).permit(
        :patient_id, :professional_id, :starts_at, :ends_at, :status, :notes
      )
    end
  end
end
