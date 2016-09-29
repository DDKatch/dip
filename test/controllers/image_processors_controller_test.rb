require 'test_helper'

class ImageProcessorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get image_processors_index_url
    assert_response :success
  end

end
