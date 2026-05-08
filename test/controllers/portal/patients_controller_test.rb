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
end
