require 'test_helper'

class TrainerInfosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trainer_info = trainer_infos(:one)
  end

  test "should get index" do
    get trainer_infos_url, as: :json
    assert_response :success
  end

  test "should create trainer_info" do
    assert_difference('TrainerInfo.count') do
      post trainer_infos_url, params: { trainer_info: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show trainer_info" do
    get trainer_info_url(@trainer_info), as: :json
    assert_response :success
  end

  test "should update trainer_info" do
    patch trainer_info_url(@trainer_info), params: { trainer_info: {  } }, as: :json
    assert_response 200
  end

  test "should destroy trainer_info" do
    assert_difference('TrainerInfo.count', -1) do
      delete trainer_info_url(@trainer_info), as: :json
    end

    assert_response 204
  end
end
