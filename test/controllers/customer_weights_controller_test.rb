require 'test_helper'

class CustomerWeightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_weight = customer_weights(:one)
  end

  test "should get index" do
    get customer_weights_url, as: :json
    assert_response :success
  end

  test "should create customer_weight" do
    assert_difference('CustomerWeight.count') do
      post customer_weights_url, params: { customer_weight: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show customer_weight" do
    get customer_weight_url(@customer_weight), as: :json
    assert_response :success
  end

  test "should update customer_weight" do
    patch customer_weight_url(@customer_weight), params: { customer_weight: {  } }, as: :json
    assert_response 200
  end

  test "should destroy customer_weight" do
    assert_difference('CustomerWeight.count', -1) do
      delete customer_weight_url(@customer_weight), as: :json
    end

    assert_response 204
  end
end
