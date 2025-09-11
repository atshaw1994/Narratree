require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @article = articles(:one)
    @comment = comments(:one)
  end

  test "should create comment if signed in" do
    sign_in @user if respond_to?(:sign_in)
    assert_difference("Comment.count") do
      post article_comments_path(@article), params: { comment: { body: "This is a valid comment body." } }
    end
    assert_response :redirect
  end

  test "should destroy comment" do
    sign_in @user if respond_to?(:sign_in)
    assert_difference("Comment.count", -1) do
      delete article_comment_path(@article, @comment)
    end
    assert_response :redirect
  end
end
