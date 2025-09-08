class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :articles, dependent: :destroy
  has_many :saved_articles, dependent: :destroy
  has_many :saved_articles_through_join_table, through: :saved_articles, source: :article
  has_many :likes, dependent: :destroy

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
