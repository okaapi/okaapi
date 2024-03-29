require 'test_helper'

module Admin

	class UserActionsControllerTest < ActionController::TestCase
	  setup do
	    ZiteActiveRecord.site( 'testsite45A67' )
	    @user_action = user_actions(:action_one)
	    @user_session = user_sessions(:session_one)
	    admin_login_4_test
	    request.host = 'testhost45A67'	    
	  end
	 
	  test "should get index" do
	    assert_difference('UserAction.count', 1) do
	      get :index
	    end
	    assert_response :success
	    assert_not_nil assigns(:user_actions)
	  end
	  
	  test "should get new" do
	    get :new
	    assert_response :success
	  end
	
	  test "should create user_action" do
	    assert_difference('UserAction.count', 2) do
	      post :create, params: { user_action: { user_session_id: user_sessions(:session_one).id } }
	    end
	    assert_redirected_to user_action_path(assigns(:user_action))
	  end
	  
	  test "should not create user_action withinvalid session " do
	    assert_difference('UserAction.count') do
	      post :create, params: { user_action: { user_session_id: 7 } }
	    end
	    assert_response :success
	  end  
	  
	  test "should not create user_action without user session" do
	    assert_difference('UserAction.count', 1) do
	      post :create, params: { user_action: { controller: "dummy" } }
	    end
	    assert_response :success
	  end    
	  
	  test "should show user_action" do
	    get :show, params: { id: @user_action }
	    assert_response :success
	  end
	
	  test "should get edit" do
	    get :edit, params: { id: @user_action }
	    assert_response :success
	  end
	
	  test "should update user_action" do
	    patch :update, params: { id: @user_action, 
		   user_action: { action: @user_action.action, 
		                  controller: @user_action.controller, 
						  user_session_id: @user_action.user_session_id } }
	    assert_redirected_to user_action_path(assigns(:user_action))
	  end
	  
	  test "should update user_action invalid" do
	    patch :update, params: { id: @user_action, 
		    user_action: { action: @user_action.action, 
			               controller: @user_action.controller, user_session_id: 7 } }
	    assert_response :success
	    assert_equal assigns(:user_action).errors.count, 1
	  end
	
	  test "should destroy user_action" do
	    assert_no_difference('UserAction.count' ) do
	      delete :destroy, params: { id: @user_action }
	    end
	
	    assert_redirected_to user_actions_path
	  end
	
	  test "should collect parameters" do
	    get :index, params: { a: "a", b: "b" }
	    actions = UserAction.order( updated_at: :desc ).first
		assert_equal actions.params, 'a: a; b: b; '
	  end
	  
	  test "should collect parameters but not kennwort or confirmation or utf" do
	    get :index, params: { kennwort: "kennw.", confirmation: "conf.", utf8: "utf" }
	    actions = UserAction.order( updated_at: :desc ).first
            assert_equal actions.params, ''
	  end
	  	  
	  test "params" do
            assert_equal user_actions(:action_one).params, "these are the parameters!"
            assert_equal user_actions(:action_two).params, "these are more parameters!"
	  end
	  
	end
	
end
