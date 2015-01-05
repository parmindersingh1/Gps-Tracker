require 'test_helper'

class GpstrackerControllerTest < ActionController::TestCase
  test "should get displaymap-blue" do
    get :displaymap-blue
    assert_response :success
  end

end
