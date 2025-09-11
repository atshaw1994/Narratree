require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @article = articles(:one)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should not create article if not signed in" do
    assert_no_difference("Article.count") do
      post articles_url, params: { article: { title: "Test", body: "This is a valid article body." } }
    end
    assert_response :redirect
  end

  # Add more tests for authenticated actions if needed
end
