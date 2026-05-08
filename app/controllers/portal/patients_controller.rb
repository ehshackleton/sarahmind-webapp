module Portal
  class PatientsController < BaseController
    before_action :set_patient, only: %i[show edit update destroy]

    def index
      @patients = policy_scope(Patient).order(created_at: :desc)
      authorize Patient
    end

    def show
      authorize @patient
      @can_view_clinical = policy(@patient).clinical_section?
      @clinical_notes = @patient.clinical_notes.includes(:professional).order(created_at: :desc)
      @clinical_note = ClinicalNote.new
    end

    def new
      @patient = Patient.new(status: "active")
      authorize @patient
    end

    def create
      @patient = Patient.new(patient_params)
      authorize @patient

      if @patient.save
        redirect_to portal_patient_path(@patient), notice: "Paciente creado correctamente."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
      authorize @patient
    end

    def update
      authorize @patient

      if @patient.update(patient_params)
        redirect_to portal_patient_path(@patient), notice: "Paciente actualizado."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize @patient
      @patient.destroy
      redirect_to portal_patients_path, notice: "Paciente eliminado."
    end

    private

    def set_patient
      @patient = policy_scope(Patient).find(params[:id])
    end

    def patient_params
      params.require(:patient).permit(
        :full_name, :email, :phone, :status, :summary, :sensitive_notes, :professional_id,
        documents: []
      )
    end
  end
end
