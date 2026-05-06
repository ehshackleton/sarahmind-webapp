require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "fixture paciente tiene rol patient" do
    assert_predicate users(:patient), :role_patient?
  end

  test "fixture admin tiene rol admin" do
    assert_predicate users(:admin), :role_admin?
  end

  test "valor de enum inválido lanza error" do
    user = users(:patient)
    assert_raises(ArgumentError) { user.role = "no_existe" }
  end
end
