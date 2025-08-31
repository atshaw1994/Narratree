class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    if current_user && current_user.saved_articles.present?
      saved_article_ids = current_user.saved_articles.map(&:to_i)
      @saved_articles = Article.where(id: saved_article_ids)
    end
  end

  def toggle_save
    @article = Article.find(params[:id])
    if current_user
      if current_user.saved_articles.include?(@article.id.to_s)
        # Unsave the article
        current_user.saved_articles.delete(@article.id.to_s)
        notice_message = "Article was successfully unsaved."
      else
        # Save the article
        current_user.saved_articles << @article.id.to_s
        notice_message = "Article was successfully saved."
      end

      if current_user.save
        redirect_to @article, notice: notice_message
      else
        redirect_to @article, alert: "Failed to update article status."
      end
    else
      redirect_to @article, alert: "You must be logged in to save or unsave articles."
    end
  end

  def show
    @article = Article.find(params[:id])
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
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, notice: "Article was successfully deleted."
  end

  private

  def article_params
    # Make sure the user_id is NOT in the list of permitted params
    params.require(:article).permit(:title, :body)
  end
end
