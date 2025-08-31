class RemoveLikesAndLikedUsersFromArticles < ActiveRecord::Migration[8.0]
  def change
    remove_column :articles, :likes, :integer
    remove_column :articles, :liked_users, :string
  end
end
