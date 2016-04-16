require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  test "should get New" do
    get :New
    assert_response :success
  end

end
