class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :role, :integer, default: 0, null: false
  end

  def down
    remove_column :users, :role
  end
end
