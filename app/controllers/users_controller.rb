class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Set the username from the email before saving
    @user.username = @user.email.split("@").first if @user.email.present?

    if @user.save
      redirect_to @user, notice: "User was successfully created."
    else
      render :new
    end
  end

  private

  def user_params
    # Make sure to permit email and password fields
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
