class AddEncryptedPasswordToUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :password_digest, :string
    remove_column :users, :password_salt, :string
  end
end
# This migration removes the password_digest and password_salt columns from the users table.
