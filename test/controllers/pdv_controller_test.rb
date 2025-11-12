require "test_helper"

class PdvControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pdv_index_url
    assert_response :success
  end
end
