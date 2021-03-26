require 'test_helper'

class CustomerRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_record = customer_records(:one)
  end

  test "should get index" do
    get customer_records_url, as: :json
    assert_response :success
  end

  test "should create customer_record" do
    assert_difference('CustomerRecord.count') do
      post customer_records_url, params: { customer_record: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show customer_record" do
    get customer_record_url(@customer_record), as: :json
    assert_response :success
  end

  test "should update customer_record" do
    patch customer_record_url(@customer_record), params: { customer_record: {  } }, as: :json
    assert_response 200
  end

  test "should destroy customer_record" do
    assert_difference('CustomerRecord.count', -1) do
      delete customer_record_url(@customer_record), as: :json
    end

    assert_response 204
  end
end
