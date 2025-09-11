require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @article = articles(:one)
    @user = users(:one)
    @comment = Comment.new(article: @article, user: @user, body: "This is a valid comment body.")
  end

  test "should be valid with valid attributes" do
    assert @comment.valid?
  end

  test "should require a user" do
    @comment.user = nil
    assert_not @comment.valid?
    assert_includes @comment.errors[:user], "can't be blank"
  end

  test "should require a body" do
    @comment.body = nil
    assert_not @comment.valid?
    assert_includes @comment.errors[:body], "can't be blank"
  end

  test "should belong to article" do
    assert_equal @article, @comment.article
  end

  test "can have replies" do
    reply = Comment.create!(article: @article, user: @user, body: "Reply", parent: @comment)
    assert_includes @comment.replies, reply
  end

  test "can have likes" do
    like = Like.create!(user: @user, likeable: @comment)
    assert_includes @comment.likes, like
  end

  test "fixtures are valid" do
    assert comments(:one).valid?
    assert comments(:two).valid?
  end
end
