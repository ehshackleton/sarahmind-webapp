require "test_helper"

class PortalTest < ActionDispatch::IntegrationTest
  test "portal redirige a inicio de sesión si no hay usuario" do
    get portal_root_url
    assert_redirected_to new_user_session_url
  end

  test "portal responde ok con rol de backoffice" do
    sign_in users(:admin)
    get portal_root_url
    assert_response :success
    assert_select "h1", text: /Resumen del espacio clínico/
    assert_select "nav[aria-label='Espacio clínico']"
    assert_select "a[href='#{portal_root_path}'][aria-current='page']", text: "Resumen"
  end

  test "portal rechaza usuario paciente" do
    sign_in users(:patient)
    get portal_root_url
    assert_redirected_to root_url
  end
end
