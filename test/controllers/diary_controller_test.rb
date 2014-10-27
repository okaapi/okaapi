require 'test_helper'

class DiaryControllerTest < ActionController::TestCase
  test "should get day" do
    get :day
    assert_response :success
  end

  test "should get week" do
    get :week
    assert_response :success
  end

  test "should get send" do
    get :send
    assert_response :success
  end

end
