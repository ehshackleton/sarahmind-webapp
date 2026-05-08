class Article < ApplicationRecord
  enum :status, {
    draft: "draft",
    published: "published"
  }, prefix: true

  belongs_to :author, class_name: "User", inverse_of: :articles
  has_rich_text :rich_body

  scope :published, -> { where(status: "published").where("published_at <= ?", Time.current) }
  scope :random_order, -> { order(Arel.sql("RANDOM()")) }

  before_validation :normalize_slug
  before_validation :normalize_legacy_body
  before_validation :set_published_at

  validates :title, presence: true
  validates :excerpt, presence: true
  validates :status, inclusion: { in: statuses.keys }
  validates :slug, presence: true, uniqueness: true
  validates :published_at, presence: true, if: :status_published?
  validate :content_presence

  def rich_body?
    rich_body&.body&.to_plain_text.to_s.strip.present?
  end

  private

  def normalize_slug
    base = slug.presence || title
    self.slug = base.to_s.parameterize
  end

  def set_published_at
    return unless status_published?
    self.published_at = Time.current if published_at.blank? || published_at.future?
  end

  def normalize_legacy_body
    self.body = "" if body.nil?
  end

  def content_presence
    return if rich_body?
    return if body.to_s.strip.present?

    errors.add(:body, "no puede estar en blanco")
  end
end
