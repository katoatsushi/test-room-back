require 'test_helper'

class CustomerStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_status = customer_statuses(:one)
  end

  test "should get index" do
    get customer_statuses_url, as: :json
    assert_response :success
  end

  test "should create customer_status" do
    assert_difference('CustomerStatus.count') do
      post customer_statuses_url, params: { customer_status: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show customer_status" do
    get customer_status_url(@customer_status), as: :json
    assert_response :success
  end

  test "should update customer_status" do
    patch customer_status_url(@customer_status), params: { customer_status: {  } }, as: :json
    assert_response 200
  end

  test "should destroy customer_status" do
    assert_difference('CustomerStatus.count', -1) do
      delete customer_status_url(@customer_status), as: :json
    end

    assert_response 204
  end
end
