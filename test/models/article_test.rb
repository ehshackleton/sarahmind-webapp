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

  test "permite contenido solo en rich_body sin body legado" do
    article = Article.new(
      title: "Guía con formato",
      excerpt: "Resumen",
      body: nil,
      status: "draft",
      author: users(:professional)
    )
    article.rich_body = "<div><strong>Texto con negrita</strong> y <em>cursiva</em></div>"

    assert article.valid?
    assert_equal "", article.body
  end

  test "si published_at está en futuro y status es published se normaliza a ahora" do
    future_time = 2.hours.from_now
    article = Article.new(
      title: "Publicación inmediata",
      excerpt: "Resumen",
      body: "Contenido",
      status: "published",
      author: users(:professional),
      published_at: future_time
    )

    freeze_time do
      assert article.valid?
      assert_in_delta Time.current.to_f, article.published_at.to_f, 1.0
    end
  end
end
