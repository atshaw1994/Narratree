class AddSavedArticlesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :saved_articles, :text
  end
end
