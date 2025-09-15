# app/controllers/users_controller.rb

class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :edit ]
  def edit
    # @user is set by before_action
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user, notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @user is now set by the before_action
    @articles = @user.articles
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile was successfully updated."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def follow
    user = User.find(params[:id])
    if current_user && current_user != user && !current_user.following.include?(user)
      current_user.following << user
    end
    redirect_to user_path(user)
  end

  def unfollow
    user = User.find(params[:id])
    if current_user && current_user != user && current_user.following.include?(user)
      current_user.following.destroy(user)
    end
    redirect_to user_path(user)
  end

  def settings
    @user = current_user
  end

  def update_settings
    @user = current_user
    prefs = params[:user][:email_notification_preferences] || {}
    # Convert string keys/values to boolean
    new_prefs = User::EMAIL_NOTIFICATION_OPTIONS.keys.index_with { |k| prefs[k.to_s] == "true" || prefs[k.to_s] == true }
    if @user.update(email_notification_preferences: new_prefs)
      redirect_to settings_path, notice: "Settings updated."
    else
      render :settings, alert: "Could not update settings."
    end
  end

  private

  # Set the @user variable before each action that needs it
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :profile_picture)
  end
end
