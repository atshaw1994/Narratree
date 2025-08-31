class InitializeSavedArticlesForExistingUsers < ActiveRecord::Migration[8.0]
  def change
    User.all.find_each do |user|
      user.update_column(:saved_articles, []) unless user.saved_articles.present?
    end
  end
end
