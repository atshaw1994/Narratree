class UserMailer < ApplicationMailer
  default from: ENV["GMAIL_USERNAME"]

  def welcome_email(user)
    @user = user
    @url  = "http://localhost:3000/login"
    mail(to: @user.email, subject: "Welcome to Narratree!")
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
end
