

class WordsControllerTest < ActionController::TestCase

   
  setup do
    @wido = Auth::User.find_by_username('wido')
    @user_session = Auth::UserSession.find_by_client('MyClient')
    @user_session.user_id = @wido.id
    @user_session.save!
    
    @word = words(:blue) 
    @word.term = 'yellow'   
    @word.user_id = @wido.id
  end
  
  def login
    @controller.session[:user_session_id] = @user_session.id
  end

  test "should get index" do
    login
    get :index    
    assert_response :success
    assert_not_nil assigns(:words)
  end


  test "should get new" do
    login
    get :new
    assert_response :success
  end

 
  test "should create word" do
    login
    assert_difference('Word.count') do
      post :create, term: { archived: @word.archived, person: @word.person, 
        priority: @word.priority, term: @word.term, user_id: @word.user_id }
    end
    assert_redirected_to word_path(assigns(:word))
  end
  

  test "should show word" do
    login
    get :show, id: @word
    assert_response :success
  end

  test "should get edit" do
    login
    get :edit, id: @word
    assert_response :success
  end

  test "should update word" do
    login
    patch :update, id: @word, term: { archived: @word.archived, person: @word.person, priority: @word.priority, term: @word.term, user_id: @word.user_id }
    assert_redirected_to word_path(assigns(:word))
  end

  test "should destroy word" do
    login
    assert_difference('Word.count', -1) do
      delete :destroy, id: @word
    end

    assert_redirected_to words_path
  end
  
end
