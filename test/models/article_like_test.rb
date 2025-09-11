require "test_helper"

class ArticleLikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @article = articles(:one)
    @article_like = ArticleLike.new(user: @user, article: @article)
  end

  test "should be valid with valid attributes" do
    assert @article_like.valid?
  end

  test "should require a user" do
    @article_like.user = nil
    assert_not @article_like.valid?
    assert_includes @article_like.errors[:user], "must exist"
  end

  test "should require an article" do
    @article_like.article = nil
    assert_not @article_like.valid?
    assert_includes @article_like.errors[:article], "must exist"
  end

  test "should belong to user" do
    assert_equal @user, @article_like.user
  end

  test "should belong to article" do
    assert_equal @article, @article_like.article
  end
end
