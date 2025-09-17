require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @article = Article.new(title: "Test Title", body: "This is a valid article body.", user: @user)
  end

  test "should be valid with valid attributes" do
    assert @article.valid?
  end

  test "should require a title" do
    @article.title = nil
    assert_not @article.valid?
    assert_includes @article.errors[:title], "can't be blank"
  end

  test "should require a body" do
    @article.body = nil
    assert_not @article.valid?
    assert_includes @article.errors[:body], "can't be blank"
  end

  test "should require body to be at least 10 characters" do
    @article.body = "short"
    assert_not @article.valid?
    assert_includes @article.errors[:body], "is too short (minimum is 10 characters)"
  end

  test "should belong to user" do
    assert_equal @user, @article.user
  end

  test "can have comments" do
    @article.save!
    comment = Comment.create!(body: "This is a valid comment body.", user: @user, article: @article)
    assert_includes @article.comments, comment
  end

  test "can have article likes" do
    @article.save!
    like = ArticleLike.create!(user: @user, article: @article)
    assert_includes @article.article_likes, like
  end

  test "can have savers through saved_articles" do
    user = User.create!(email: "test@example.com", username: "testuser", first_name: "Test", last_name: "User", password: "password", accepted_guidelines: true)
    article = Article.create!(title: "Test", body: "This is a valid article body.", user: user)
    SavedArticle.create!(user: user, article: article)
    article.reload
    assert_includes article.savers, user
  end
end
