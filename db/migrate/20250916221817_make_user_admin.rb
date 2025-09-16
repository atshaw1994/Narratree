class MakeUserAdmin < ActiveRecord::Migration[8.0]
  def up
    user = User.find_by(email: "atshaw1994@gmail.com")
    user.update(admin: true) if user
  end
end
