require "test_helper"

module Portal
  class DashboardMetricsTest < ActiveSupport::TestCase
    include ActiveSupport::Testing::TimeHelpers

    test "upcoming_sessions respeta el alcance de sesiones" do
      admin = users(:admin)
      patient_scope = Pundit.policy_scope!(admin, Patient)
      session_scope = Pundit.policy_scope!(admin, TherapySession)

      snapshot = DashboardMetrics.new(patient_scope: patient_scope, session_scope: session_scope)
      list = snapshot.upcoming_sessions(limit: 20)

      assert list.all? { |s| s.starts_at >= Time.zone.now }
      assert list.all?(&:status_scheduled?)
    end

    test "sessions_today lista citas programadas del día actual" do
      travel_to Time.zone.parse("2026-06-15 12:00:00") do
        admin = users(:admin)
        patient_scope = Pundit.policy_scope!(admin, Patient)
        session_scope = Pundit.policy_scope!(admin, TherapySession)
        snapshot = DashboardMetrics.new(patient_scope: patient_scope, session_scope: session_scope)

        assert_operator snapshot.to_h[:sessions_today], :>=, 1
        assert(snapshot.today_scheduled_sessions.all? { |s| s.starts_at.to_date == Date.new(2026, 6, 15) })
      end
    end
  end
end
