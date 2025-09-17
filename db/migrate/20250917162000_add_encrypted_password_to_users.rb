class AddEncryptedPasswordToUsers < ActiveRecord::Migration[7.1]
  def change
  remove_column :users, :password_digest, :string
  end
end
# This migration removes the password_digest and password_salt columns from the users table.
