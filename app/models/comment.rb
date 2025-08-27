class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  validates :user, presence: true
  validates :body, presence: true
end
