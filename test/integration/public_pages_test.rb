require "test_helper"

class PublicPagesTest < ActionDispatch::IntegrationTest
  test "quienes somos responde OK" do
    get about_url
    assert_response :success
    assert_select "h1", text: "Quiénes somos"
  end

  test "cursos responde OK" do
    get courses_url
    assert_response :success
    assert_select "h1", text: "Catálogo de cursos"
  end

  test "tips responde OK" do
    get tips_url
    assert_response :success
    assert_select "h1", text: "Tips y ejercicios"
  end

  test "noticias responde OK" do
    get news_url
    assert_response :success
    assert_select "h1", text: "Noticias y recursos"
    assert_match articles(:published_professional).title, response.body
  end

  test "detalle de noticia publicada responde OK" do
    get news_article_url(slug: articles(:published_professional).slug)
    assert_response :success
    assert_select "h1", text: articles(:published_professional).title
    assert_match "https://x.com/intent/tweet", response.body
  end

  test "contacto responde OK" do
    get contact_url
    assert_response :success
    assert_select "h1", text: "Contacto"
  end
end
