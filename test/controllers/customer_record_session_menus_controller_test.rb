require 'test_helper'

class CustomerRecordSessionMenusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_record_session_menu = customer_record_session_menus(:one)
  end

  test "should get index" do
    get customer_record_session_menus_url, as: :json
    assert_response :success
  end

  test "should create customer_record_session_menu" do
    assert_difference('CustomerRecordSessionMenu.count') do
      post customer_record_session_menus_url, params: { customer_record_session_menu: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show customer_record_session_menu" do
    get customer_record_session_menu_url(@customer_record_session_menu), as: :json
    assert_response :success
  end

  test "should update customer_record_session_menu" do
    patch customer_record_session_menu_url(@customer_record_session_menu), params: { customer_record_session_menu: {  } }, as: :json
    assert_response 200
  end

  test "should destroy customer_record_session_menu" do
    assert_difference('CustomerRecordSessionMenu.count', -1) do
      delete customer_record_session_menu_url(@customer_record_session_menu), as: :json
    end

    assert_response 204
  end
end
