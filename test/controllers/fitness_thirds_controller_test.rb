require 'test_helper'

class FitnessThirdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fitness_third = fitness_thirds(:one)
  end

  test "should get index" do
    get fitness_thirds_url, as: :json
    assert_response :success
  end

  test "should create fitness_third" do
    assert_difference('FitnessThird.count') do
      post fitness_thirds_url, params: { fitness_third: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show fitness_third" do
    get fitness_third_url(@fitness_third), as: :json
    assert_response :success
  end

  test "should update fitness_third" do
    patch fitness_third_url(@fitness_third), params: { fitness_third: {  } }, as: :json
    assert_response 200
  end

  test "should destroy fitness_third" do
    assert_difference('FitnessThird.count', -1) do
      delete fitness_third_url(@fitness_third), as: :json
    end

    assert_response 204
  end
end
