class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_likeable, only: [ :create, :destroy ]

  def create
    @like = @likeable.likes.new(user: current_user)
    if @like.save
      # Redirect back to the comment's page
      redirect_to @likeable.article, notice: "Liked successfully."
    else
      redirect_to @likeable.article, alert: "Unable to like."
    end
  end

  def destroy
    @like = @likeable.likes.find_by(user: current_user)
    if @like.destroy
      redirect_to @likeable.article, notice: "Unliked successfully."
    else
      redirect_to @likeable.article, alert: "Unable to unlike."
    end
  end

  private

  def set_likeable
    if params[:comment_id]
      @likeable = Comment.find(params[:comment_id])
    end
  end
end
