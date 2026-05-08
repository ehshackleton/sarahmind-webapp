module Portal
  class ClinicalNotesController < BaseController
    def create
      @patient = policy_scope(Patient).find(params[:patient_id])
      @clinical_note = @patient.clinical_notes.new(clinical_note_params.merge(professional: current_user))
      authorize @clinical_note

      if @clinical_note.save
        redirect_to portal_patient_path(@patient), notice: "Nota interna registrada."
      else
        redirect_to portal_patient_path(@patient), alert: "No se pudo guardar la nota interna."
      end
    end

    private

    def clinical_note_params
      params.require(:clinical_note).permit(:body)
    end
  end
end
