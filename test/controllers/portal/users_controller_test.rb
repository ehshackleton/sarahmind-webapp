require "test_helper"

class Portal::UsersControllerTest < ActionDispatch::IntegrationTest
  test "system_admin puede cambiar rol y genera auditoria" do
    sign_in users(:system_admin)

    assert_difference -> { AuditEvent.where(action: "security.role_changed").count }, 1 do
      patch portal_user_url(users(:admin)), params: { user: { role: "professional" } }
    end

    assert_redirected_to portal_users_url
  end

  test "admin no puede cambiar roles" do
    sign_in users(:admin)
    patch portal_user_url(users(:professional)), params: { user: { role: "patient" } }
    assert_response :not_found
  end
end
