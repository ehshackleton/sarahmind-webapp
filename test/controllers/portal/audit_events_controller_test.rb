require "test_helper"

class Portal::AuditEventsControllerTest < ActionDispatch::IntegrationTest
  test "system_admin puede ver auditoria" do
    sign_in users(:system_admin)
    get portal_audit_events_url
    assert_response :success
    assert_select "h1", text: "Auditoría y trazabilidad"
  end

  test "admin no puede ver auditoria" do
    sign_in users(:admin)
    get portal_audit_events_url
    assert_redirected_to root_url
  end

  test "system_admin puede abrir guia de retencion" do
    sign_in users(:system_admin)
    get retention_guide_portal_audit_events_url
    assert_response :success
    assert_select "h1", text: "Guía de auditoría y retención"
    assert_match(/Auditoría y retención de datos/, response.body)
  end

  test "admin no puede abrir guia de retencion" do
    sign_in users(:admin)
    get retention_guide_portal_audit_events_url
    assert_redirected_to root_url
  end
end
