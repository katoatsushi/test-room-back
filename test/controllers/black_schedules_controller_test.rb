require 'test_helper'

class BlackSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @black_schedule = black_schedules(:one)
  end

  test "should get index" do
    get black_schedules_url, as: :json
    assert_response :success
  end

  test "should create black_schedule" do
    assert_difference('BlackSchedule.count') do
      post black_schedules_url, params: { black_schedule: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show black_schedule" do
    get black_schedule_url(@black_schedule), as: :json
    assert_response :success
  end

  test "should update black_schedule" do
    patch black_schedule_url(@black_schedule), params: { black_schedule: {  } }, as: :json
    assert_response 200
  end

  test "should destroy black_schedule" do
    assert_difference('BlackSchedule.count', -1) do
      delete black_schedule_url(@black_schedule), as: :json
    end

    assert_response 204
  end
end
