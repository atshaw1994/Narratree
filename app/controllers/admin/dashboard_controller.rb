class Admin::DashboardController < ApplicationController
  # Ensure user is authenticated
  before_action :authenticate_user!
  # Ensure user is an admin or owner
  before_action :require_admin

  def index
    if mobile_device?
      # Renders the mobile-specific view and uses the application layout by default.
      render "admin/mobile_dashboard/index"
    else
      # Renders the existing desktop view.
      render "admin/dashboard/index"
    end
  end

  private

  def require_admin
    unless current_user&.admin_or_owner?
      redirect_to root_path, alert: "You are not authorized to access the admin dashboard."
    end
  end

  def mobile_device?
    request.user_agent.to_s.downcase =~ /android|webos|iphone|ipad|ipod|blackberry|windows phone/
  end
end
