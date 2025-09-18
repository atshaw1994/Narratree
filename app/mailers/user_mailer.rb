class UserMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]

  def account_approved_email(user)
    @user = user
    @url = login_url
    mail(to: @user.email, subject: "Your Narratree account has been approved!")
  end

  # Notifies the owner when a new user signs up
  def new_user_waiting_approval(user)
    @user = user
    @approve_url = url_for(controller: "admin/users", action: "approve", id: @user.id, only_path: false)
    owner = User.find_by(role: :owner)
    mail(to: owner.email, subject: "New user awaiting approval: #{@user.username}")
  end

  def welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/login"
    mail(to: @user.email, subject: "Welcome to Narratree!")
  end

  def user_warned_email(user, admin_message)
    @user = user
    @admin_message = admin_message
    mail(to: @user.email, subject: "Account Warning from Narratree Admin")
  end

  def article_liked_email(article, liker)
    @article = article
    @liker = liker
    @url = "http://localhost:3000/articles/#{article.id}"
    mail(to: article.user.email, subject: "Your article was liked!")
  end

  def article_commented_email(article, commenter, comment)
    @article = article
    @commenter = commenter
    @comment = comment
    @url = "http://localhost:3000/articles/#{article.id}"
    mail(to: article.user.email, subject: "New comment on your article!")
  end

  def followed_email(user, follower)
    @user = user
    @follower = follower
    @url = user_url(@follower)
    mail(to: @user.email, subject: "You have a new follower!")
  end
end
