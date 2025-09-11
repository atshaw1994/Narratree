require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @comment = comments(:one)
  end

  test "should create like if signed in" do
    sign_in @user if respond_to?(:sign_in)
    assert_difference("Like.count") do
      post article_comment_likes_path(@comment.article, @comment)
    end
    assert_response :redirect
  end

  test "should destroy like if signed in" do
    sign_in @user if respond_to?(:sign_in)
    like = Like.create!(user: @user, likeable: @comment)
    assert_difference("Like.count", -1) do
      delete article_comment_like_path(@comment.article, @comment, like)
    end
    assert_response :redirect
  end
end
