class AddEmailNotificationPreferencesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :email_notification_preferences, :json
  end
end
