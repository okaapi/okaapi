require 'test_helper'

class WordsControllerTest < ActionController::TestCase
  setup do
    @user_arnaud = Auth::User.new( username: 'arnaud', email: 'arnaud@gmail.com', active: 'confirmed',
                                   password: 'secret', password_confirmation: 'secret')
    @user_arnaud.save!       
    @word = words(:one)
    @word.user_id = @user_arnaud.id
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
      post :create, term: { archived: @word.archived, person: @word.person, priority: @word.priority, term: @word.term, user_id: @word.user_id }
    end

    assert_redirected_to word_path(assigns(:word))
  end

  test "should show word" do
    get :show, id: @word
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @word
    assert_response :success
  end

  test "should update word" do
    patch :update, id: @word, term: { archived: @word.archived, person: @word.person, priority: @word.priority, term: @word.term, user_id: @word.user_id }
    assert_redirected_to word_path(assigns(:word))
  end

  test "should destroy word" do
    assert_difference('Word.count', -1) do
      delete :destroy, id: @word
    end

    assert_redirected_to words_path
  end
end
