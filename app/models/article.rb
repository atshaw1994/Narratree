class Article < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
  has_many :users, through: :article_likes
  has_many :saved_articles, dependent: :destroy
  has_many :savers, through: :saved_articles, source: :user

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  has_many_attached :photos
end
