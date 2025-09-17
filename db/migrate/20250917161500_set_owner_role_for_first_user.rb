class SetOwnerRoleForFirstUser < ActiveRecord::Migration[6.0]
  def up
    user = User.find_by(id: 1)
    user.update_column(:role, 3) if user
  end

  def down
    user = User.find_by(id: 1)
    user.update_column(:role, 0) if user
  end
end
