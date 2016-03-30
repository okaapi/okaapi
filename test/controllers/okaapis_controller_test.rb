require 'test_helper'


	module Admin
	class OkaapisControllerTest < ActionController::TestCase
	  setup do
		ZiteActiveRecord.site( 'testsite45A67' )
	    request.host = 'testhost45A67'	    
	    @user = users(:wido)
	    admin_login_4_test
	    
	    @okaapi = okaapis(:okaapi_one)    
	    @okaapi.user_id = @user.id
	  end	
	  
	  test "should get index" do
	    
	    get :index
	    assert_response :success
	    assert_not_nil assigns(:okaapis)
	  end
	
	  test "should get new" do
	    
	    get :new
	    assert_response :success
	  end
	
	  test "should create okaapi" do
	    
	    assert_difference('Okaapi.count') do
	      post :create, okaapi: { archived: @okaapi.archived, content: @okaapi.content, 
	        from: @okaapi.from, reminder: @okaapi.reminder, subject: @okaapi.subject, 
	        time: @okaapi.time, user_id: @okaapi.user_id }
	    end
	
	    assert_redirected_to okaapi_path(assigns(:okaapi))
	  end
	
	  test "should show okaapi" do
	    
	    get :show, id: @okaapi
	    assert_response :success
	  end
	
	  test "should get edit" do
	    
	    get :edit, id: @okaapi
	    assert_response :success
	  end
	
	  test "should update okaapi" do
	    
	    patch :update, id: @okaapi, okaapi: { archived: @okaapi.archived, content: @okaapi.content, 
	       from: @okaapi.from, reminder: @okaapi.reminder, subject: @okaapi.subject, 
	       time: @okaapi.time, user_id: @okaapi.user_id }
	    assert_redirected_to okaapi_path(assigns(:okaapi))
	  end
	
	  test "should destroy okaapi" do
	    
	    assert_difference('Okaapi.count', -1) do
	      delete :destroy, id: @okaapi
	    end
	
	    assert_redirected_to okaapis_path
	  end
	end
end
