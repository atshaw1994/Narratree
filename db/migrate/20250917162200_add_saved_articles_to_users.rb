class AddSavedArticlesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :saved_articles, :text
  end
end
