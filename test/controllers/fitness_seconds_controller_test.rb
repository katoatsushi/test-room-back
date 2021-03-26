require 'test_helper'

class FitnessSecondsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fitness_second = fitness_seconds(:one)
  end

  test "should get index" do
    get fitness_seconds_url, as: :json
    assert_response :success
  end

  test "should create fitness_second" do
    assert_difference('FitnessSecond.count') do
      post fitness_seconds_url, params: { fitness_second: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show fitness_second" do
    get fitness_second_url(@fitness_second), as: :json
    assert_response :success
  end

  test "should update fitness_second" do
    patch fitness_second_url(@fitness_second), params: { fitness_second: {  } }, as: :json
    assert_response 200
  end

  test "should destroy fitness_second" do
    assert_difference('FitnessSecond.count', -1) do
      delete fitness_second_url(@fitness_second), as: :json
    end

    assert_response 204
  end
end
