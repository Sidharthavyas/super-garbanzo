require "test_helper"

class AutodialerControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get autodialer_index_url
    assert_response :success
  end
end
