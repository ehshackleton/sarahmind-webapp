class Article < ApplicationRecord
  enum :status, {
    draft: "draft",
    published: "published"
  }, prefix: true

  belongs_to :author, class_name: "User", inverse_of: :articles

  scope :published, -> { where(status: "published").where("published_at <= ?", Time.current) }
  scope :random_order, -> { order(Arel.sql("RANDOM()")) }

  before_validation :normalize_slug
  before_validation :set_published_at

  validates :title, presence: true
  validates :excerpt, presence: true
  validates :body, presence: true
  validates :status, inclusion: { in: statuses.keys }
  validates :slug, presence: true, uniqueness: true
  validates :published_at, presence: true, if: :status_published?

  private

  def normalize_slug
    base = slug.presence || title
    self.slug = base.to_s.parameterize
  end

  def set_published_at
    return unless status_published?
    self.published_at ||= Time.current
  end
end
