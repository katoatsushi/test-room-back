require 'test_helper'

class FitnessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fitness = fitnesses(:one)
  end

  test "should get index" do
    get fitnesses_url, as: :json
    assert_response :success
  end

  test "should create fitness" do
    assert_difference('Fitness.count') do
      post fitnesses_url, params: { fitness: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show fitness" do
    get fitness_url(@fitness), as: :json
    assert_response :success
  end

  test "should update fitness" do
    patch fitness_url(@fitness), params: { fitness: {  } }, as: :json
    assert_response 200
  end

  test "should destroy fitness" do
    assert_difference('Fitness.count', -1) do
      delete fitness_url(@fitness), as: :json
    end

    assert_response 204
  end
end
