# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
  before_action :set_article, only: [ :create, :reply_form ]

  def create
    @comment = @article.comments.new(comment_params)
    @comment.user = current_user
    @comment.parent_id = params[:comment][:parent_id] if params[:comment][:parent_id].present?

    if @comment.save
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
    @comment.destroy
    redirect_to @comment.article
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
end
