module Portal
  class ArticlesController < BaseController
    before_action :set_article, only: %i[show edit update destroy]

    def index
      @articles = policy_scope(Article).includes(:author).order(created_at: :desc)
      authorize Article
    end

    def show
      authorize @article
    end

    def new
      @article = Article.new(status: :draft)
      authorize @article
    end

    def create
      @article = Article.new(article_params)
      @article.author = current_user
      authorize @article

      if @article.save
        log_audit!("article.create", auditable: @article)
        redirect_to portal_article_path(@article), notice: "Artículo creado correctamente."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
      authorize @article
    end

    def update
      authorize @article

      if @article.update(article_params)
        changed_fields = @article.previous_changes.keys.map(&:to_s).excluding("updated_at").sort
        log_audit!("article.update", auditable: @article, metadata: { fields: changed_fields }) if changed_fields.any?
        redirect_to portal_article_path(@article), notice: "Artículo actualizado."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      authorize @article
      slug = @article.slug
      @article.destroy
      log_audit!("article.destroy", metadata: { slug: slug })
      redirect_to portal_articles_path, notice: "Artículo eliminado."
    end

    private

    def set_article
      @article = policy_scope(Article).find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :slug, :excerpt, :body, :status, :published_at)
    end
  end
end
