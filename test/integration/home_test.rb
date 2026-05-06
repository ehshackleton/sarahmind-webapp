require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "root muestra SarahMind" do
    get root_url
    assert_response :success
    assert_select "h1", text: /SarahMind|Acompañamiento/
  end
end
