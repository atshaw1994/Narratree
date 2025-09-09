# app/controllers/users_controller.rb

class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update ]

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

  private

  # Set the @user variable before each action that needs it
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :profile_picture)
  end
end
