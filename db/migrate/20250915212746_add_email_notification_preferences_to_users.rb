class AddEmailNotificationPreferencesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :email_notification_preferences, :json
  end
end
