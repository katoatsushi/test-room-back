require 'test_helper'

class FitnessFourthsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fitness_fourth = fitness_fourths(:one)
  end

  test "should get index" do
    get fitness_fourths_url, as: :json
    assert_response :success
  end

  test "should create fitness_fourth" do
    assert_difference('FitnessFourth.count') do
      post fitness_fourths_url, params: { fitness_fourth: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show fitness_fourth" do
    get fitness_fourth_url(@fitness_fourth), as: :json
    assert_response :success
  end

  test "should update fitness_fourth" do
    patch fitness_fourth_url(@fitness_fourth), params: { fitness_fourth: {  } }, as: :json
    assert_response 200
  end

  test "should destroy fitness_fourth" do
    assert_difference('FitnessFourth.count', -1) do
      delete fitness_fourth_url(@fitness_fourth), as: :json
    end

    assert_response 204
  end
end
