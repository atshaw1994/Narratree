# Generates a dynamic sitemap.xml
class SitemapController < ApplicationController
  def index
    @articles = Article.all # Add other models as needed
    @users = User.all
    respond_to do |format|
      format.xml
    end
  end
end
