# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def new
    # Renders the login form
  end

  def create
    # Find the user by their email
    user = User.find_by(email: params[:email])

    # Check if the user exists and the password is correct
    if user && user.authenticate(params[:password])
      # Log the user in by setting the user_id in the session
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully!"
    else
      # Re-render the form with an error message
      flash.now[:alert] = "Invalid email or password"
      render :new
    end
  end

  def destroy
    # Log the user out by clearing the session
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully!"
  end
end
