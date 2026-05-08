require "test_helper"

class PublicSiteNavTest < ActionDispatch::IntegrationTest
  test "sitio público incluye menú móvil accesible" do
    get root_url
    assert_response :success
    assert_select "details.public-mobile-nav"
    assert_select "summary[aria-label='Menú de navegación']"
    assert_select "nav[aria-label='Principal (móvil)']"
  end
end
