require "test_helper"

class Admin::TickersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_tickers_index_url
    assert_response :success
  end
end
