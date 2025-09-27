class User < ApplicationRecord
  # Counter for admin warnings
  validates :warnings_count, numericality: { greater_than_or_equal_to: 0 }
  # User following associations
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable
  include DeviseLoginWithEmailOrUsername
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :saved_article_joins, class_name: "SavedArticle", dependent: :destroy
  has_many :saved_articles, through: :saved_article_joins, source: :article
  has_many :likes, dependent: :destroy
  has_one_attached :profile_picture

  before_validation :set_default_saved_articles

  EMAIL_NOTIFICATION_OPTIONS = {
    like: "A user likes your article",
    comment: "A user comments on your article",
    follow: "A user follows you",
    mention: "You are mentioned in a comment or article"
  }.freeze

  after_initialize :set_default_email_notification_preferences, if: :new_record?

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :accepted_guidelines, inclusion: { in: [ true ], message: "must be accepted" }

  enum :role, { user: 0, moderator: 1, admin: 2, owner: 3 }

  # Use Rails enum predicate methods: user?, moderator?, admin?, owner? (now user_role?)
  # If you need custom logic for admin or moderator, define as below:
  def admin_or_owner?
    admin? || owner?
  end

  def moderator_or_higher?
    moderator? || admin? || owner?
  end

  # Follows another user
  def follow(other_user)
    return if self == other_user || following.include?(other_user)
    following << other_user
  end

  # Unfollows another user
  def unfollow(other_user)
    following.destroy(other_user)
  end

  def set_default_email_notification_preferences
    # Migration-safe: only set if column exists and no error
    if has_attribute?(:email_notification_preferences)
  # Use a compatible approach for all Ruby versions and migration safety
  self.email_notification_preferences ||= Hash[EMAIL_NOTIFICATION_OPTIONS.keys.map { |k| [ k, true ] }]
    end
  rescue StandardError
    # Ignore errors during migrations
  end

  def email_notification_enabled?(key)
    email_notification_preferences && email_notification_preferences[key.to_s]
  end

  def update_email_notification_preference(key, value)
    prefs = (email_notification_preferences || {}).dup
    prefs[key.to_s] = value
    update(email_notification_preferences: prefs)
  end

  # Only allow login if approved
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  private

  def set_default_saved_articles
    self.saved_article_joins ||= []
  end
end
