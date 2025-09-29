# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    resource.skip_confirmation_notification! if resource.respond_to?(:skip_confirmation_notification!)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      UserMailer.new_user_waiting_approval(resource).deliver_later
      set_flash_message! :notice, :signed_up_but_unapproved
      expire_data_after_sign_in!
      redirect_to root_path, notice: "Your account is awaiting approval by the site owner."
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end
