require "stringio"
require "google/apis/calendar_v3"
require "googleauth"

module GoogleCalendar
  class Api
    class << self
      def upsert_event!(therapy_session)
        return unless configured?

        service = calendar_service
        return if service.blank?

        event = build_event(therapy_session)

        if therapy_session.google_calendar_event_id.present?
          service.patch_event(calendar_id, therapy_session.google_calendar_event_id, event)
        else
          inserted = service.insert_event(calendar_id, event)
          therapy_session.update_column(:google_calendar_event_id, inserted.id)
        end
      rescue Google::Apis::Error, ArgumentError => e
        Rails.logger.warn("[GoogleCalendar] upsert TherapySession##{therapy_session.id}: #{e.class}: #{e.message}")
      end

      def delete_event!(therapy_session)
        return if therapy_session.google_calendar_event_id.blank?
        return unless configured?

        service = calendar_service
        return if service.blank?

        service.delete_event(calendar_id, therapy_session.google_calendar_event_id)
        therapy_session.update_column(:google_calendar_event_id, nil)
      rescue Google::Apis::ClientError => e
        Rails.logger.warn("[GoogleCalendar] delete TherapySession##{therapy_session.id}: #{e.message}")
        therapy_session.update_column(:google_calendar_event_id, nil) if e.status_code == 404
      rescue Google::Apis::Error => e
        Rails.logger.warn("[GoogleCalendar] delete TherapySession##{therapy_session.id}: #{e.message}")
      end

      def delete_event_by_id!(google_event_id)
        return if google_event_id.blank?
        return unless configured?

        service = calendar_service
        return if service.blank?

        service.delete_event(calendar_id, google_event_id)
      rescue Google::Apis::ClientError => e
        Rails.logger.warn("[GoogleCalendar] delete id=#{google_event_id}: #{e.message}") unless e.status_code == 404
      rescue Google::Apis::Error => e
        Rails.logger.warn("[GoogleCalendar] delete id=#{google_event_id}: #{e.message}")
      end

      private

      def configured?
        credentials_path.present? && File.exist?(credentials_path) && calendar_id.present?
      end

      def credentials_path
        ENV["GOOGLE_CALENDAR_CREDENTIALS_PATH"].to_s.presence
      end

      def calendar_id
        ENV["GOOGLE_CALENDAR_CALENDAR_ID"].to_s.presence
      end

      def calendar_service
        authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
          json_key_io: StringIO.new(File.read(credentials_path)),
          scope: Google::Apis::CalendarV3::AUTH_CALENDAR_EVENTS
        )
        svc = Google::Apis::CalendarV3::CalendarService.new
        svc.authorization = authorizer
        svc
      end

      def build_event(therapy_session)
        tz = Time.zone.tzinfo.name
        Google::Apis::CalendarV3::Event.new(
          summary: "SarahMind · #{therapy_session.patient.full_name}",
          description: therapy_session.notes.presence,
          start: Google::Apis::CalendarV3::EventDateTime.new(
            date_time: therapy_session.starts_at.iso8601,
            time_zone: tz
          ),
          end: Google::Apis::CalendarV3::EventDateTime.new(
            date_time: therapy_session.ends_at.iso8601,
            time_zone: tz
          )
        )
      end
    end
  end
end
