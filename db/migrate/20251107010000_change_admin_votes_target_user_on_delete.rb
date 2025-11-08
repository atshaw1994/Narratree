class ChangeAdminVotesTargetUserOnDelete < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :admin_votes, column: :target_user_id
    add_foreign_key :admin_votes, :users, column: :target_user_id, on_delete: :nullify
  end
end
