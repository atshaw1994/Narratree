class SetOwnerRoleForFirstUser < ActiveRecord::Migration[6.0]
  def up
    user = User.find_by(id: 1)
    user.update(role: :owner) if user
  end

  def down
    user = User.find_by(id: 1)
    user.update(role: :user) if user
  end
end
