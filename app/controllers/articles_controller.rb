class ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [
    :toggle_save,
    :like,
    :unlike,
    :create,
    :edit,
    :update,
    :destroy
  ]

  before_action :set_article, only: [
    :show,
    :edit,
    :update,
    :destroy,
    :toggle_save,
    :like,
    :unlike
  ]

  def index
    if params[:query].present?
      @articles = Article.where("LOWER(title) LIKE ?", "%#{params[:query].downcase}%")
    else
        @articles = Article.order(created_at: :desc).page(params[:page]).per(10)
    end

    if user_signed_in?
      @saved_articles = current_user.saved_articles_through_join_table
    end

    respond_to do |format|
      format.html # Renders the full HTML page
      format.turbo_stream # Renders the turbo_stream.erb template
    end
  end

  def toggle_save
    if user_signed_in?
      saved_article = current_user.saved_articles.find_by(article: @article)

      if saved_article
        saved_article.destroy
        notice_message = "Article unpinned."
      else
        current_user.saved_articles.create(article: @article)
        notice_message = "Article pinned."
      end
      redirect_back fallback_location: root_path, notice: notice_message
    else
      redirect_to @article, alert: "You must be logged in to pin or unpin articles."
    end
  end

  def like
    @article.article_likes.create(user: current_user)
    redirect_to @article, notice: "Article liked."
  end

  def unlike
    @like = @article.article_likes.find_by(user: current_user)
    @like.destroy
    redirect_to @article, notice: "Article unliked."
  end

  def show
    @comment = @article.comments.build
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to root_path, notice: "Article was successfully deleted."
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
