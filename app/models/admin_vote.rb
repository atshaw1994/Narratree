class AdminVote < ApplicationRecord
  belongs_to :initiator, class_name: "User"
  belongs_to :target_user, class_name: "User", optional: true
  enum :status, { pending: 0, completed: 1, owner_decided: 2 }
  enum :vote_type, { delete_user: 0 }

  validates :vote_type, :status, :initiator_id, presence: true
end
