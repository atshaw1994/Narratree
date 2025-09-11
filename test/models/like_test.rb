require "test_helper"

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @article = articles(:one)
    @comment = comments(:one)
    @like_on_article = Like.new(user: @user, likeable: @article)
    @like_on_comment = Like.new(user: @user, likeable: @comment)
  end

  test "should be valid for article" do
    assert @like_on_article.valid?
  end

  test "should be valid for comment" do
    assert @like_on_comment.valid?
  end

  test "should require a user" do
    @like_on_article.user = nil
    assert_not @like_on_article.valid?
    assert_includes @like_on_article.errors[:user], "must exist"
  end

  test "should require a likeable" do
    @like_on_article.likeable = nil
    assert_not @like_on_article.valid?
    assert_includes @like_on_article.errors[:likeable], "must exist"
  end

  test "should enforce uniqueness of user scoped to likeable" do
    @like_on_article.save!
    duplicate_like = Like.new(user: @user, likeable: @article)
    assert_not duplicate_like.valid?
    assert_includes duplicate_like.errors[:user_id], "has already been taken"
  end
end
