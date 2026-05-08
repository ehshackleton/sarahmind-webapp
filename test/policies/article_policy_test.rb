require "test_helper"

class ArticlePolicyTest < ActiveSupport::TestCase
  test "professional puede actualizar articulo propio" do
    policy = ArticlePolicy.new(users(:professional), articles(:published_professional))
    assert policy.update?
  end

  test "professional no puede actualizar articulo de otro autor" do
    policy = ArticlePolicy.new(users(:professional), articles(:published_admin))
    assert_not policy.update?
  end

  test "admin puede actualizar cualquier articulo" do
    policy = ArticlePolicy.new(users(:admin), articles(:published_professional))
    assert policy.update?
  end

  test "scope para professional solo incluye propios" do
    scope = ArticlePolicy::Scope.new(users(:professional), Article).resolve
    assert_includes scope, articles(:published_professional)
    assert_not_includes scope, articles(:published_admin)
  end
end
