require 'test_helper'

class OjtTopControllerTest < ActionDispatch::IntegrationTest
  test "should get kanri" do
    get ojt_top_kanri_url
    assert_response :success
  end

  test "should get user" do
    get ojt_top_user_url
    assert_response :success
  end

end
