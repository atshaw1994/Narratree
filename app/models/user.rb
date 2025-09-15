class User < ApplicationRecord
  # User following associations
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :articles, dependent: :destroy
  has_many :saved_articles, dependent: :destroy
  has_many :saved_articles_through_join_table, through: :saved_articles, source: :article
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

  def admin?
    self.admin
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
    self.email_notification_preferences ||= EMAIL_NOTIFICATION_OPTIONS.keys.index_with { true }
  end

  def email_notification_enabled?(key)
    email_notification_preferences && email_notification_preferences[key.to_s]
  end

  def update_email_notification_preference(key, value)
    prefs = (email_notification_preferences || {}).dup
    prefs[key.to_s] = value
    update(email_notification_preferences: prefs)
  end

  private

  def set_default_saved_articles
    self.saved_articles ||= []
  end
end
