require "test_helper"

class PortalTest < ActionDispatch::IntegrationTest
  test "portal redirige a inicio de sesión si no hay usuario" do
    get portal_root_url
    assert_redirected_to new_user_session_url
  end

  test "portal responde ok con usuario autenticado" do
    sign_in users(:patient)
    get portal_root_url
    assert_response :success
    assert_select "h1", text: /Portal privado/
  end
end
