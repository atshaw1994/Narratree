require "test_helper"

class TickerMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticker_message = ticker_messages(:one)
  end

  test "should create ticker message" do
    assert_difference("TickerMessage.count", 1) do
      post ticker_messages_url, params: { ticker_message: { message: "Test ticker message" } }
    end
    assert_redirected_to admin_dashboard_path(tab: "tickerbar")
  end

  test "should destroy ticker message" do
    assert_difference("TickerMessage.count", -1) do
      delete ticker_message_url(@ticker_message)
    end
    assert_redirected_to admin_dashboard_path(tab: "tickerbar")
  end
end
