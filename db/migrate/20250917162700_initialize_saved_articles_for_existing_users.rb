class InitializeSavedArticlesForExistingUsers < ActiveRecord::Migration[7.1]
  def change
    User.all.find_each do |user|
      user.update_column(:saved_articles, []) unless user.saved_articles.present?
    end
  end
end
