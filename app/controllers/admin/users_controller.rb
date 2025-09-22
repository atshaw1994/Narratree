class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_owner!

  def index
    @users = User.all
  end

  def update_role
    @user = User.find(params[:id])
    if current_user.admin_or_owner? && User.roles.keys.include?(params[:role])
      @user.update(role: params[:role])
      render json: { success: true, role: @user.role }
    else
      render json: { success: false }, status: :forbidden
    end
  end

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

  # Approve a pending user
  def approve
    @user = User.find(params[:id])
    if @user.update(approved: true)
      UserMailer.account_approved_email(@user).deliver_later
      if params[:desktop]
        redirect_to admin_dashboard_path, notice: "User approved."
      else
        redirect_to admin_users_path, notice: "User approved."
      end
    else
      if params[:desktop]
        redirect_to admin_dashboard_path, alert: "Could not approve user."
      else
        redirect_to admin_users_path, alert: "Could not approve user."
      end
    end
  end

  # Reject (delete) a pending user
  def reject
    @user = User.find(params[:id])
    if @user.destroy
      if params[:desktop]
        redirect_to admin_dashboard_path, notice: "User rejected and deleted."
      else
        redirect_to admin_users_path, notice: "User rejected and deleted."
      end
    else
      if params[:desktop]
        redirect_to admin_dashboard_path, alert: "Could not reject user."
      else
        redirect_to admin_users_path, alert: "Could not reject user."
      end
    end
  end

  # Delete a user and all associated data
  def destroy
    unless current_user.admin_or_owner?
      redirect_to root_path, alert: "Not authorized." and return
    end
    user = User.find(params[:id])
    user.destroy
    redirect_to admin_dashboard_path, notice: "User and all associated data deleted."
  end

  private

  def require_admin_or_owner!
    unless current_user&.admin_or_owner?
      redirect_to root_path, alert: "Not authorized."
    end
  end
end
