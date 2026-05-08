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
  end

  test "contacto responde OK" do
    get contact_url
    assert_response :success
    assert_select "h1", text: "Contacto"
  end
end
