class CreateAdminVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_votes do |t|
      t.integer :vote_type, null: false
      t.integer :status, default: 0, null: false
      t.references :initiator, null: false, foreign_key: { to_table: :users }
      t.references :target_user, foreign_key: { to_table: :users }
      t.jsonb :votes, default: {}
      t.boolean :result
      t.text :reason
      t.datetime :completed_at
      t.timestamps
    end
  end
end
