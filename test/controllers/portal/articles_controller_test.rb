require "test_helper"

class Portal::ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "professional ve sus articulos en index" do
    sign_in users(:professional)

    get portal_articles_url
    assert_response :success
    assert_select "h1", text: "Artículos"
    assert_match articles(:published_professional).title, response.body
  end

  test "professional no puede ver articulo de otro autor" do
    sign_in users(:professional)

    get portal_article_url(articles(:published_admin))
    assert_response :not_found
  end

  test "admin puede actualizar articulo de professional" do
    sign_in users(:admin)

    patch portal_article_url(articles(:published_professional)), params: {
      article: { title: "Título actualizado admin" }
    }

    assert_redirected_to portal_article_url(articles(:published_professional))
    assert_equal "Título actualizado admin", articles(:published_professional).reload.title
  end

  test "professional crea articulo como autor actual" do
    sign_in users(:professional)

    assert_difference("Article.count", 1) do
      post portal_articles_url, params: {
        article: {
          title: "Nuevo recurso práctico",
          slug: "nuevo-recurso-practico",
          excerpt: "Resumen práctico",
          body: "",
          rich_body: "<div><strong>Contenido</strong> detallado con <em>formato</em>.</div>",
          status: "published"
        }
      }
    end

    created = Article.order(created_at: :desc).first
    assert_equal users(:professional).id, created.author_id
    assert_includes created.rich_body.to_plain_text, "Contenido"
  end
end
