class FlagsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_moderator!

  def create
    flaggable = find_flaggable
    if flaggable
      flaggable.flags.create(user: current_user, reason: params[:reason])
      redirect_back fallback_location: root_path, notice: "Flagged for review."
    else
      redirect_back fallback_location: root_path, alert: "Could not flag item."
    end
  end

  private

  def require_moderator!
    unless current_user&.moderator? || current_user&.admin? || current_user&.owner?
      redirect_to root_path, alert: "Not authorized."
    end
  end

  def find_flaggable
    if params[:article_id]
      Article.find_by(id: params[:article_id])
    elsif params[:comment_id]
      Comment.find_by(id: params[:comment_id])
    end
  end
end
