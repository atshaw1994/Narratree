class Admin::ArticlesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @articles = Article.all.order(created_at: :desc)
  end

  private

  def require_admin
    redirect_to root_path unless current_user&.admin_or_owner?
  end
end
