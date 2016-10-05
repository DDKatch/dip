require 'test_helper'

class HomeworksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get homeworks_index_url
    assert_response :success
  end

end
