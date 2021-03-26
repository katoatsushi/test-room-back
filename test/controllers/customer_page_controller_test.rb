require 'test_helper'

class CustomerPageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get customer_page_index_url
    assert_response :success
  end

  test "should get show" do
    get customer_page_show_url
    assert_response :success
  end

end
