class User < ApplicationRecord
  has_secure_password
  has_many :articles
  serialize :saved_articles, coder: JSON

  before_validation :set_default_saved_articles

  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  private

  def set_default_saved_articles
    self.saved_articles ||= []
  end
end
