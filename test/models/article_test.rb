require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "genera slug desde el titulo cuando falta" do
    article = Article.new(
      title: "Nuevo Recurso de Ayuda",
      excerpt: "Resumen corto",
      body: "Contenido",
      status: "draft",
      author: users(:professional)
    )

    assert article.valid?
    assert_equal "nuevo-recurso-de-ayuda", article.slug
  end

  test "requiere published_at cuando status es published" do
    article = Article.new(
      title: "Articulo publicado",
      excerpt: "Resumen",
      body: "Contenido",
      status: "published",
      slug: "articulo-publicado",
      author: users(:professional),
      published_at: nil
    )

    assert article.valid?
    assert article.published_at.present?
  end

  test "scope published solo trae publicados vigentes" do
    ids = Article.published.pluck(:id)

    assert_includes ids, articles(:published_professional).id
    assert_includes ids, articles(:published_admin).id
    assert_not_includes ids, articles(:draft_professional).id
  end
end
