class CommentsController < ApplicationController
  before_action :set_article, only: [ :create, :reply_form ]
  before_action :require_approved_user!, only: [ :create ]

  def create
    @comment = @article.comments.new(comment_params)
    @comment.user = current_user
    @comment.parent_id = params[:comment][:parent_id] if params[:comment][:parent_id].present?

    if @comment.save
      # Send notification email to the article author (unless the commenter is the author)
      if @article.user != current_user
        UserMailer.article_commented_email(@article, current_user, @comment).deliver_later
      end
      respond_to do |format|
        format.html { redirect_to @article }
        format.turbo_stream
      end
    else
      render "articles/show"
    end
  end

  def reply_form
    @comment = Comment.find(params[:id])
    render partial: "comments/reply_form", locals: { article: @article, comment: @comment }
  end

  def destroy
    @comment = Comment.find(params[:id])
    unless can_delete_comment?(@comment)
      redirect_to @comment.article, alert: "Not authorized to delete this comment." and return
    end
    @comment.destroy
    redirect_to @comment.article
  end

  private

  def can_delete_comment?(comment)
    return false unless current_user
    current_user.admin? || current_user.owner? || comment.user == current_user
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def require_approved_user!
    unless current_user&.approved?
      redirect_to @article, alert: "Your account must be approved before you can post comments."
    end
  end
end
