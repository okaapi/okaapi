require 'test_helper'



class OkaapisControllerTest < ActionController::TestCase
  setup do
    @wido = Auth::User.find_by_username('wido')
    @user_session = Auth::UserSession.find_by_client('MyClient')
    @user_session.user_id = @wido.id
    @user_session.save!
    
    @okaapi = okaapis(:okaapi_one)    
    @okaapi.user_id = @wido.id
  end

  def login
    @controller.session[:user_session_id] = @user_session.id
  end
  
  test "should get index" do
    login
    get :index
    assert_response :success
    assert_not_nil assigns(:okaapis)
  end

  test "should get new" do
    login
    get :new
    assert_response :success
  end

  test "should create okaapi" do
    login
    assert_difference('Okaapi.count') do
      post :create, okaapi: { archived: @okaapi.archived, content: @okaapi.content, 
        from: @okaapi.from, reminder: @okaapi.reminder, subject: @okaapi.subject, 
        time: @okaapi.time, user_id: @okaapi.user_id }
    end

    assert_redirected_to okaapi_path(assigns(:okaapi))
  end

  test "should show okaapi" do
    login
    get :show, id: @okaapi
    assert_response :success
  end

  test "should get edit" do
    login
    get :edit, id: @okaapi
    assert_response :success
  end

  test "should update okaapi" do
    login
    patch :update, id: @okaapi, okaapi: { archived: @okaapi.archived, content: @okaapi.content, 
       from: @okaapi.from, reminder: @okaapi.reminder, subject: @okaapi.subject, 
       time: @okaapi.time, user_id: @okaapi.user_id }
    assert_redirected_to okaapi_path(assigns(:okaapi))
  end

  test "should destroy okaapi" do
    login
    assert_difference('Okaapi.count', -1) do
      delete :destroy, id: @okaapi
    end

    assert_redirected_to okaapis_path
  end
end
