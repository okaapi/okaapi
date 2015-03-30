require 'test_helper'


class OkaapiMailer < ActionMailer::Base
  def self.get_okaapis
    [ { time: Time.now, from: 'wido@menhardt.com', 
          content: 'content 1', subject: 'red green blue' },
      { time: Time.now + 1000, from: 'john_alternate@menhardt.com', 
          content: 'content 2', subject: 'Red blue purple' },
      { time: Time.now + 2000, from: 'arnaud@gmail.com', 
          content: 'content 2', subject: 'yellow gray green' } ]                        
  end
end

class OkaapiControllerTest < ActionController::TestCase
  
  setup do
    @wido = User.find_by_username('wido')
    @user_session = UserSession.find_by_client('MyClient')
    @user_session.user_id = @wido.id
    @user_session.save!
    
    Okaapi.all.each do |o|
      o.user_id = @wido.id
      o.save!
    end 
    Word.all.each do |o|
      o.user_id = @wido.id
      o.save!
    end     
    @not_java = ! Rails.configuration.use_javascript
  end
  def login
    @controller.session[:user_session_id] = @user_session.id
  end
  
  test "receive okaapis" do 
    # wido@menhardt.com and john@menhardt.com are known users, so they get added,
    # but arnaud@gmail.com is ignored...
    assert_difference('Okaapi.count', +2) do
      get :receive_okaapi_emails
      assert_redirected_to root_path
    end
    
  end
  
  test "should get termcloud" do
    login
    get :termcloud
    assert_response :success    
    assert_not_nil assigns(:current_user)
    assert_not_nil assigns(:termcloud)

    assert_select ".term_size_1", 6
    assert_select ".term_size_2", 1    

  end
  
  test "should get termdetail" do
    login    
    if ! @not_java
      xhr :get, :term_detail, word_id: words(:blue).id
      assert_select_jquery :html, '#term_detail_dialogue' do    
        assert_select 'button a', 1
      end 
    else
      get :term_detail, word_id: words(:blue).id
      assert_response :success
      assert_select '#term_detail_dialogue' do    
        assert_select 'button a', 1
      end 
    end
    
  end
  
  test "show content" do
    login
    @id = Okaapi.first
    get :show_okaapi_content, id: @id.id
    assert_response :success 
    assert_select '#application', /text two/
  end
  

  test "show people" do
    login
    get :people
    
    assert_select ".person", 2 
    assert_select '#people span a', /John/
    assert_select '#people span a', /Peter/
  end
  
  test "show mindmap" do
    login
    get :mindmap
    assert_select ".mindmap_cluster span a", /blue/ 
    assert_select ".mindmap_cluster span a", /petrol/
    assert_select ".mindmap_cluster span a", 9
    assert_select ".mindmap_cluster", 2
  end
  
  test "show mindmap limits" do
    login
    get :mindmap, drilldown: ['red']
    assert_select ".mindmap_cluster span a", /blue/ 
    assert_select ".mindmap_cluster span a", /violet/
    assert_select ".mindmap_cluster span a", 4
    assert_select ".mindmap_cluster", 2
  end
  
  test "toggle person" do
    @request.env['HTTP_REFERER'] = 'http://test.com'
    login
    assert_equal  words(:blue).person, "false"
    get :toggle_person, id: words(:blue).id
    assert_redirected_to :back
    assert_equal Word.find( words(:blue).id ).person, "true"
  end
  
  test "priority up" do
    @request.env['HTTP_REFERER'] = 'http://test.com'
    login
    assert_equal  words(:blue).priority, 0
    get :priority, id: words(:blue).id, increment: 1
    assert_equal Word.find( words(:blue).id ).priority, 1
  end 
  
  test "priority down" do
    @request.env['HTTP_REFERER'] = 'http://test.com'
    login
    assert_equal  words(:blue).priority, 0
    get :priority, id: words(:blue).id, increment: -1
    assert_equal Word.find( words(:blue).id ).priority, 0
  end     
  
  test "archive" do
    @request.env['HTTP_REFERER'] = 'http://test.com'
    login
    assert_equal  words(:blue).archived, 'false'
    get :archive_word, id: words(:blue).id
    assert_not_equal Word.find( words(:blue).id ).archived, 'false'
  end       

  test "undo archive" do
    @request.env['HTTP_REFERER'] = 'http://test.com'
    login
    assert_equal  words(:archived).archived, 'true'
    get :undo_archive_word
    assert_equal Word.find( words(:archived).id ).archived, 'false'
  end  
  
  test "archive okaapi" do
    @request.env['HTTP_REFERER'] = 'http://test.com'
    login
    assert_equal  okaapis(:okaapi_one).archived, 'false'
    get :archive_okaapi, id: okaapis(:okaapi_one).id
    assert_not_equal Okaapi.find( okaapis(:okaapi_one).id ).archived, 'false'
  end       

  test "undo archive okaapi" do
    @request.env['HTTP_REFERER'] = 'http://test.com'
    login
    assert_not_equal  okaapis(:okaapi_five).archived, 'false'
    get :undo_archive_okaapi
    assert_equal Okaapi.find( okaapis(:okaapi_five).id ).archived, 'false'
  end  
  
end
