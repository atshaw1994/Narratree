  has_many :flags, as: :flaggable, dependent: :destroy
class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :user, presence: true
  validates :body, presence: true
end
