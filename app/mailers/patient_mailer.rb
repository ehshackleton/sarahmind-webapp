class PatientMailer < ApplicationMailer
  def therapy_session_scheduled(therapy_session)
    @therapy_session = therapy_session
    @patient = therapy_session.patient

    mail(to: @patient.email, subject: default_i18n_subject(patient_name: @patient.full_name))
  end
end
