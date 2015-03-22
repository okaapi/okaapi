require 'test_helper'

class DiaryEntriesControllerTest < ActionController::TestCase
  setup do
    @wido = User.find_by_username('wido')
    @user_session = UserSession.find_by_client('MyClient')
    @user_session.user_id = @wido.id
    @user_session.save!
    
    @diary_entry = diary_entries(:one)    
    @diary_entry.user_id = @wido.id
  end

  def login
    @controller.session[:user_session_id] = @user_session.id
  end
  
  test "should get index" do
    login
    get :index
    assert_response :success
    assert_not_nil assigns(:diary_entries)
  end

  test "should get new" do
    login
    get :new
    assert_response :success
  end

  test "should create diary_entry" do
    login
    assert_difference('DiaryEntry.count') do
      post :create, diary_entry: { archived: @diary_entry.archived, day: @diary_entry.day, 
        content: @diary_entry.content, month: @diary_entry.month, user_id: @diary_entry.user_id, 
        year: @diary_entry.year }
    end

    assert_redirected_to diary_entry_path(assigns(:diary_entry))
  end

  test "should show diary_entry" do
    login
    get :show, id: @diary_entry
    assert_response :success
  end

  test "should get edit" do
    login
    get :edit, id: @diary_entry
    assert_response :success
  end

  test "should update diary_entry" do
    login
    patch :update, id: @diary_entry, diary_entry: { archived: @diary_entry.archived, 
      day: @diary_entry.day, content: @diary_entry.content, month: @diary_entry.month, 
      user_id: @diary_entry.user_id, year: @diary_entry.year }
    assert_redirected_to diary_entry_path(assigns(:diary_entry))
  end

  test "should destroy diary_entry" do
    login
    assert_difference('DiaryEntry.count', -1) do
      delete :destroy, id: @diary_entry
    end

    assert_redirected_to diary_entries_path
  end
end
