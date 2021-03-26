require 'test_helper'

class CustomerInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_info = customer_infos(:one)
  end

  test "should get index" do
    get customer_infos_url, as: :json
    assert_response :success
  end

  test "should create customer_info" do
    assert_difference('CustomerInfo.count') do
      post customer_infos_url, params: { customer_info: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show customer_info" do
    get customer_info_url(@customer_info), as: :json
    assert_response :success
  end

  test "should update customer_info" do
    patch customer_info_url(@customer_info), params: { customer_info: {  } }, as: :json
    assert_response 200
  end

  test "should destroy customer_info" do
    assert_difference('CustomerInfo.count', -1) do
      delete customer_info_url(@customer_info), as: :json
    end

    assert_response 204
  end
end
