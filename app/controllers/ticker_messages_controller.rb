class TickerMessagesController < ApplicationController
  before_action :set_ticker_message, only: [ :destroy ]

  def create
    @ticker_message = TickerMessage.new(ticker_message_params)
    if @ticker_message.save
      if request.referer&.include?(admin_tickers_path)
        redirect_to admin_tickers_path, notice: "Ticker message created."
      else
        redirect_to admin_dashboard_path(tab: "tickerbar"), notice: "Ticker message created."
      end
    else
      if request.referer&.include?(admin_tickers_path)
        redirect_to admin_tickers_path, alert: "Failed to create ticker message."
      else
        redirect_to admin_dashboard_path(tab: "tickerbar"), alert: "Failed to create ticker message."
      end
    end
  end

  def destroy
    @ticker_message.destroy
    if request.referer&.include?(admin_tickers_path)
      redirect_to admin_tickers_path, notice: "Ticker message deleted."
    else
      redirect_to admin_dashboard_path(tab: "tickerbar"), notice: "Ticker message deleted."
    end
  end

  private

  def set_ticker_message
    @ticker_message = TickerMessage.find(params[:id])
  end

  def ticker_message_params
    params.require(:ticker_message).permit(:message)
  end
end
