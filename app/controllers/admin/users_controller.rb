class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def warn
    @user = User.find(params[:user_id] || params[:id])
    admin_message = params[:admin_message].presence || "No message provided."
    @user.increment!(:warnings_count)
    UserMailer.user_warned_email(@user, admin_message).deliver_later
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@user) }
      format.html { redirect_to admin_dashboard_path, notice: "Warning sent to user." }
    end
  end

  private

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "Not authorized."
    end
  end
end
