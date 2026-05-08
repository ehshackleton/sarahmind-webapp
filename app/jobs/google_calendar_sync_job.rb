class GoogleCalendarSyncJob < ApplicationJob
  queue_as :default

  def perform(therapy_session_id)
    therapy_session = TherapySession.find_by(id: therapy_session_id)
    return if therapy_session.blank?

    if therapy_session.status_scheduled?
      GoogleCalendar::Api.upsert_event!(therapy_session)
    elsif therapy_session.google_calendar_event_id.present?
      GoogleCalendar::Api.delete_event!(therapy_session)
    end
  end
end
