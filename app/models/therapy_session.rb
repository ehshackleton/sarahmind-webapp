class TherapySession < ApplicationRecord
  belongs_to :patient
  belongs_to :professional, class_name: "User", inverse_of: :led_therapy_sessions

  enum :status,
       { scheduled: "scheduled", completed: "completed", cancelled: "cancelled" },
       prefix: true,
       default: :scheduled

  validates :starts_at, :ends_at, presence: true
  validate :ends_after_starts
  validate :professional_is_clinician

  after_commit :notify_patient_if_scheduled, on: %i[create update]
  after_commit :enqueue_google_calendar_sync, on: %i[create update]

  before_destroy :capture_google_calendar_event_id
  after_destroy_commit :enqueue_google_calendar_event_deletion

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, :invalid) if ends_at <= starts_at
  end

  def professional_is_clinician
    return if professional.blank?

    return if professional.role_professional? || professional.role_system_admin?

    errors.add(:professional_id, :invalid)
  end

  def notify_patient_if_scheduled
    return if patient.email.blank?
    return unless status_scheduled?

    keys = previous_changes.keys
    return unless (keys & %w[id starts_at ends_at status]).any?

    PatientMailer.therapy_session_scheduled(self).deliver_later
  end

  def enqueue_google_calendar_sync
    keys = previous_changes.keys
    return unless (keys & %w[id starts_at ends_at status]).any?

    return unless status_scheduled? || status_cancelled? || status_completed?

    GoogleCalendarSyncJob.perform_later(id)
  end

  def capture_google_calendar_event_id
    @google_calendar_event_id_to_delete = google_calendar_event_id
  end

  def enqueue_google_calendar_event_deletion
    return if @google_calendar_event_id_to_delete.blank?

    GoogleCalendarEventDeleteJob.perform_later(@google_calendar_event_id_to_delete)
  end
end
