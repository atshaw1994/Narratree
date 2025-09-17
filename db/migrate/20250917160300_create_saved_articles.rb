class CreateSavedArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_articles do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
