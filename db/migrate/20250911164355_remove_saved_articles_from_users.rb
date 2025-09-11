class RemoveSavedArticlesFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :saved_articles, :text
  end
end
