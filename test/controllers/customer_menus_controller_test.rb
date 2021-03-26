require 'test_helper'

class CustomerMenusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_menu = customer_menus(:one)
  end

  test "should get index" do
    get customer_menus_url, as: :json
    assert_response :success
  end

  test "should create customer_menu" do
    assert_difference('CustomerMenu.count') do
      post customer_menus_url, params: { customer_menu: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show customer_menu" do
    get customer_menu_url(@customer_menu), as: :json
    assert_response :success
  end

  test "should update customer_menu" do
    patch customer_menu_url(@customer_menu), params: { customer_menu: {  } }, as: :json
    assert_response 200
  end

  test "should destroy customer_menu" do
    assert_difference('CustomerMenu.count', -1) do
      delete customer_menu_url(@customer_menu), as: :json
    end

    assert_response 204
  end
end
