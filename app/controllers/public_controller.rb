class PublicController < ApplicationController
  def about; end

  def courses; end

  def tips; end

  def news
    @articles = Article.published.includes(:author).random_order.limit(9)
  end

  def news_article
    @article = Article.published.find_by!(slug: params[:slug])
  end

  def contact; end
end
