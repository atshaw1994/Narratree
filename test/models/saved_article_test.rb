require "test_helper"

class SavedArticleTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @article = articles(:one)
    @saved_article = SavedArticle.new(user: @user, article: @article)
  end

  test "should be valid with valid attributes" do
    assert @saved_article.valid?
  end

  test "should require a user" do
    @saved_article.user = nil
    assert_not @saved_article.valid?
    assert_includes @saved_article.errors[:user], "must exist"
  end

  test "should require an article" do
    @saved_article.article = nil
    assert_not @saved_article.valid?
    assert_includes @saved_article.errors[:article], "must exist"
  end

  test "should belong to user" do
    assert_equal @user, @saved_article.user
  end

  test "should belong to article" do
    assert_equal @article, @saved_article.article
  end
end
