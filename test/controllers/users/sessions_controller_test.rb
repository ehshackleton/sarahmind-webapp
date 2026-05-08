require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "inicio de sesión exitoso registra session.sign_in" do
    assert_difference -> { AuditEvent.where(action: "session.sign_in").count }, 1 do
      post user_session_path, params: { user: { email: users(:professional).email, password: "password123" } }
    end
    assert_response :redirect
  end

  test "inicio de sesión fallido no registra session.sign_in" do
    assert_no_difference -> { AuditEvent.where(action: "session.sign_in").count } do
      post user_session_path, params: { user: { email: users(:professional).email, password: "incorrecta" } }
    end
    assert_response :unprocessable_content
  end

  test "cierre de sesión registra session.sign_out" do
    sign_in users(:professional)
    assert_difference -> { AuditEvent.where(action: "session.sign_out").count }, 1 do
      delete destroy_user_session_path
    end
    assert_response :redirect
  end
end
