# Create owner account if it doesn't exist, with retry workaround for Devise mapping error
begin
  User.find_or_create_by!(email: "atshaw1994@gmail.com") do |user|
    user.first_name = "Aaron"
    user.last_name = "Shaw"
    user.username = "atshaw1994"
    user.password = "Hazel1021!"
    user.password_confirmation = "Hazel1021!"
    user.role = "owner"
    user.accepted_guidelines = true
  end
rescue RuntimeError => e
  if e.message =~ /valid mapping/
    sleep 1
    retry
  else
    raise
  end
end
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed ticker messages
[
  "Welcome to Narratree!",
  "Check out the latest articles and updates.",
  "Follow us on social media for more news.",
  "Contact support if you have any questions."
].each do |msg|
  TickerMessage.find_or_create_by!(message: msg)
end
