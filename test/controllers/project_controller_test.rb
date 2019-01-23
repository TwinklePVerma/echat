require 'test_helper'

class ProjectControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get project_create_url
    assert_response :success
  end

end
