
require 'test_helper'

module Admin

	class WordsControllerTest < ActionController::TestCase
		   
	  setup do
	    ZiteActiveRecord.site( 'testsite45A67' )
        request.host = 'testhost45A67'	    
        @user = users(:wido)
        admin_login_4_test
        
	    @word = words(:blue) 
	    @word.term = 'yellow'   
	    @word.user_id = @user.id
	    
	  end
	
	  test "should get index" do
	    get :index    
	    assert_response :success
	    assert_not_nil assigns(:words)
	  end	    
	

	  test "should get new" do
	    get :new
	    assert_response :success
	  end
	
	 
	  test "should create word" do
	    assert_difference('Word.count') do
	      post :create, params: { term: { archived: @word.archived, person: @word.person, 
	        priority: @word.priority, term: @word.term, user_id: @word.user_id } }
	    end
	    assert_redirected_to word_path(assigns(:word))
	  end
	  
	
	  test "should show word" do
	    get :show, params: { id: @word }
	    assert_response :success
	  end
	
	  test "should get edit" do
	    get :edit, params: { id: @word }
	    assert_response :success
	  end
	
	  test "should update word" do
	    patch :update, params: { id: @word, 
		   term: { archived: @word.archived, person: @word.person, 
		           priority: @word.priority, term: @word.term, user_id: @word.user_id } }
	    assert_redirected_to word_path(assigns(:word))
	  end
	
	  test "should destroy word" do
	    assert_difference('Word.count', -1) do
	      delete :destroy, params: { id: @word }
	    end
	
	    assert_redirected_to words_path
	  end
	  
    end
    
end
