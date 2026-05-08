class GoogleCalendarEventDeleteJob < ApplicationJob
  queue_as :default

  def perform(google_event_id)
    GoogleCalendar::Api.delete_event_by_id!(google_event_id)
  end
end
