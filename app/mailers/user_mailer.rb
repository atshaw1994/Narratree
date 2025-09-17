class UserMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]


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
