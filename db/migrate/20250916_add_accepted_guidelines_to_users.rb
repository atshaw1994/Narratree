class AddAcceptedGuidelinesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :accepted_guidelines, :boolean, default: false, null: false
  end
end
