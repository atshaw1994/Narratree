class RemoveSavedArticlesFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :saved_articles, :text
  end
end
