require "test_helper"

class PatientTest < ActiveSupport::TestCase
  test "next_upcoming_session devuelve la próxima cita programada" do
    patient = patients(:one)
    assert_kind_of TherapySession, patient.next_upcoming_session
    assert patient.next_upcoming_session.starts_at >= Time.zone.now
    assert patient.next_upcoming_session.status_scheduled?
  end
end
