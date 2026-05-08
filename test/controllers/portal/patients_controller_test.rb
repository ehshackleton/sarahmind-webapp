require "test_helper"

class Portal::PatientsControllerTest < ActionDispatch::IntegrationTest
  test "patient role no accede a listado backoffice" do
    sign_in users(:patient)
    get portal_patients_url
    assert_redirected_to root_url
  end

  test "admin puede ver listado de pacientes" do
    sign_in users(:admin)
    get portal_patients_url
    assert_response :success
    assert_select "h1", text: "Pacientes"
  end

  test "professional crea nota clínica interna" do
    sign_in users(:professional)
    assert_difference("ClinicalNote.count", 1) do
      post portal_patient_clinical_notes_url(patients(:one)), params: { clinical_note: { body: "Nota interna nueva" } }
    end
    assert_redirected_to portal_patient_url(patients(:one))
  end

  test "professional al ver paciente asignado registra patient.clinical_read" do
    sign_in users(:professional)
    assert_difference -> { AuditEvent.where(action: "patient.clinical_read").count }, 1 do
      get portal_patient_url(patients(:one))
    end
    assert_response :success
  end

  test "admin ve paciente pero no registra patient.clinical_read" do
    sign_in users(:admin)
    assert_no_difference -> { AuditEvent.where(action: "patient.clinical_read").count } do
      get portal_patient_url(patients(:one))
    end
    assert_response :success
  end

  test "professional al cambiar notas sensibles registra patient.clinical_update" do
    sign_in users(:professional)
    assert_difference -> { AuditEvent.where(action: "patient.clinical_update").count }, 1 do
      patch portal_patient_url(patients(:one)), params: { patient: { sensitive_notes: "Actualizado en auditoría test" } }
    end
    assert_redirected_to portal_patient_url(patients(:one))
  end

  test "descarga de documento adjunto registra patient.document_download" do
    sign_in users(:professional)
    patient = patients(:one)
    patient.documents.attach(
      io: StringIO.new("contenido de prueba"),
      filename: "informe.pdf",
      content_type: "application/pdf"
    )
    attachment = patient.documents.attachments.first
    assert_difference -> { AuditEvent.where(action: "patient.document_download").count }, 1 do
      get download_document_portal_patient_url(patient, attachment_id: attachment.id)
    end
    assert_response :redirect
  end
end
