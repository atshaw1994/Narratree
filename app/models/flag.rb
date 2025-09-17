class Flag < ApplicationRecord
  belongs_to :user
  belongs_to :flaggable, polymorphic: true
  validates :reason, length: { maximum: 250 }
end
