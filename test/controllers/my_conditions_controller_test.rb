require 'test_helper'

class MyConditionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @my_condition = my_conditions(:one)
  end

  test "should get index" do
    get my_conditions_url, as: :json
    assert_response :success
  end

  test "should create my_condition" do
    assert_difference('MyCondition.count') do
      post my_conditions_url, params: { my_condition: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show my_condition" do
    get my_condition_url(@my_condition), as: :json
    assert_response :success
  end

  test "should update my_condition" do
    patch my_condition_url(@my_condition), params: { my_condition: {  } }, as: :json
    assert_response 200
  end

  test "should destroy my_condition" do
    assert_difference('MyCondition.count', -1) do
      delete my_condition_url(@my_condition), as: :json
    end

    assert_response 204
  end
end
