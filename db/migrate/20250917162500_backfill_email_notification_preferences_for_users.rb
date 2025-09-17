class BackfillEmailNotificationPreferencesForUsers < ActiveRecord::Migration[7.1]
  def up
    default_prefs = {
      "like" => true,
      "comment" => true,
      "follow" => true,
      "mention" => true
    }
    User.where("email_notification_preferences IS NULL OR email_notification_preferences::text = '{}'").find_each do |user|
      user.update_column(:email_notification_preferences, default_prefs)
    end
  end

  def down
    # No-op
  end
end
