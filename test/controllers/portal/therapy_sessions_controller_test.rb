require "test_helper"

class Portal::TherapySessionsControllerTest < ActionDispatch::IntegrationTest
  test "paciente no accede a agenda" do
    sign_in users(:patient)
    get portal_therapy_sessions_url
    assert_redirected_to root_url
  end

  test "profesional ve listado de sesiones" do
    sign_in users(:professional)
    get portal_therapy_sessions_url
    assert_response :success
    assert_select "h1", text: "Agenda de sesiones"
  end

  test "profesional crea sesión y envía correo al paciente con email" do
    sign_in users(:professional)
    starts = 3.days.from_now.change(hour: 11, min: 0, sec: 0)
    ends_at = starts + 50.minutes

    assert_difference("TherapySession.count", 1) do
      assert_emails 1 do
        post portal_therapy_sessions_url, params: {
          therapy_session: {
            patient_id: patients(:one).id,
            professional_id: users(:professional).id,
            starts_at: starts.iso8601,
            ends_at: ends_at.iso8601,
            status: "scheduled",
            notes: "Primera sesión"
          }
        }
      end
    end

    assert_redirected_to portal_therapy_session_url(TherapySession.order(:created_at).last)
  end

  test "admin actualiza estado a cancelada" do
    sign_in users(:admin)
    session = therapy_sessions(:one)
    patch portal_therapy_session_url(session), params: {
      therapy_session: { status: "cancelled" }
    }
    assert_redirected_to portal_therapy_session_url(session)
    assert_equal "cancelled", session.reload.status
  end
end
