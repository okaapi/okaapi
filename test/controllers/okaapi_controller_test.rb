require 'test_helper'

class OkaapiMailer < ActionMailer::Base
  def self.get_okaapis
    [ { time: Time.now, from: 'wido@mmm.com', 
          content: 'content 1', subject: 'red green blue' },
      { time: Time.now + 1000, from: 'john_alternate@menhardt.com', 
          content: 'content 2', subject: 'Red blue purple' },
      { time: Time.now + 2000, from: 'arnaud@gmail.com', 
          content: 'content 2', subject: 'yellow gray green' } ]                        
  end
end

class OkaapiControllerTest < ActionController::TestCase
  
  setup do
	ZiteActiveRecord.site( 'testsite45A67' )
    request.host = 'testhost45A67'	    
    login_4_test
    session[:okaapi_mode] = nil
    Okaapi.all.each do |o|
      o.user_id = @current_user.id
      o.save!
    end 
    Word.all.each do |o|
      o.user_id = @current_user.id
      o.save!
    end     

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
    
    get :termcloud
    assert_response :success    
    assert_not_nil assigns(:current_user)
    assert_not_nil assigns(:termcloud)

    assert_select ".term_size_1", 6
    assert_select ".term_size_2", 1    

  end
  

  test "should get termdetail" do
        
    [true,false].each do |java|                 
        Rails.configuration.use_javascript = java
        @not_java = ! Rails.configuration.use_javascript        
	    if ! @not_java
	      get :term_detail, xhr: true, params: { word_id: words(:blue).id }
	      assert_select_jquery :html, '#term_detail_dialogue' do    
	        assert_select 'button a', 1
	      end 
	    else
		  begin
	        get :term_detail, params: { word_id: words(:blue).id }
		  rescue Exception => e
		    puts "strange message in okaapi_controller_test:"
		    puts e		    
		  end		   
	      assert_response :success
	      assert_select '#term_detail_dialogue' do    
	        assert_select 'button a', 1
	      end 
	    end
    end
    
  end
  
  test "show content" do
    
    @id = Okaapi.first
    get :show_okaapi_content, params: { id: @id.id }
    assert_response :success 
    assert_select '#application', /text two/
  end
  
 
  test "show people" do
    
    get :people
    
    assert_select ".person", 2 
    assert_select '#people span a', /John/
    assert_select '#people span a', /Peter/
  end
  
  test "show mindmap" do
    
    get :mindmap
    assert_select ".mindmap_cluster span a", /blue/ 
    assert_select ".mindmap_cluster span a", /petrol/
    assert_select ".mindmap_cluster span a", 9
    assert_select ".mindmap_cluster", 2
  end
  
  test "show mindmap limits" do
    
    get :mindmap, params: { drilldown: ['red'] }
    assert_select ".mindmap_cluster span a", /blue/ 
    assert_select ".mindmap_cluster span a", /violet/
    assert_select ".mindmap_cluster span a", 4
    assert_select ".mindmap_cluster", 2
  end

  test "toggle person" do
    assert_equal  words(:blue).person, "false"
    get :toggle_person, params: { id: words(:blue).id }
    assert_redirected_to 'http://testhost45A67/okaapi/term_detail?word_id=' + words(:blue).id.to_s
    assert_equal Word.find( words(:blue).id ).person, "true"
  end

  test "priority up" do
    assert_equal  words(:blue).priority, 0
    get :priority, params: { id: words(:blue).id, increment: 1 }
	assert_redirected_to 'http://testhost45A67/okaapi/term_detail?word_id=' + words(:blue).id.to_s
    assert_equal Word.find( words(:blue).id ).priority, 1
  end 
  
  test "priority down" do 
    assert_equal  words(:blue).priority, 0
    get :priority, params: { id: words(:blue).id, increment: -1 }
	assert_redirected_to 'http://testhost45A67/okaapi/term_detail?word_id=' + words(:blue).id.to_s
    assert_equal Word.find( words(:blue).id ).priority, 0
  end     
  
  
  test "archive" do
    assert_equal  words(:blue).archived, 'false'
    get :archive_word, params: { id: words(:blue).id }
	assert_redirected_to 'http://testhost45A67/'
    assert_not_equal Word.find( words(:blue).id ).archived, 'false'
  end       

  test "archive with termcloud" do
    session[:okaapi_mode] = 'termcloud' 
    assert_equal  words(:blue).archived, 'false'
    get :archive_word, params: { id: words(:blue).id }
	assert_redirected_to 'http://testhost45A67/okaapi/termcloud' 
    assert_not_equal Word.find( words(:blue).id ).archived, 'false'
  end   
  
  test "undo archive" do
    assert_equal  words(:archived).archived, 'true'
    get :undo_archive_word
	assert_redirected_to 'http://testhost45A67/okaapi/term_detail?word_id=' + words(:archived).id.to_s
    assert_equal Word.find( words(:archived).id ).archived, 'false'
  end  
  

  test "archive okaapi" do
    assert_equal  okaapis(:okaapi_one).archived, 'false'
    get :archive_okaapi, params: { id: okaapis(:okaapi_one).id }
	assert_redirected_to 'http://testhost45A67/'	
    assert_not_equal Okaapi.find( okaapis(:okaapi_one).id ).archived, 'false'
  end       
  
  test "archive okaapi termcloud" do
    session[:okaapi_mode] = 'termcloud' 
    assert_equal  okaapis(:okaapi_one).archived, 'false'
    get :archive_okaapi, params: { id: okaapis(:okaapi_one).id }
	assert_redirected_to 'http://testhost45A67/okaapi/termcloud'	
    assert_not_equal Okaapi.find( okaapis(:okaapi_one).id ).archived, 'false'
  end        
   
  test "undo archive okaapi" do 
    assert_not_equal  okaapis(:okaapi_five).archived, 'false'
    get :undo_archive_okaapi
	assert_redirected_to 'http://testhost45A67/'	
    assert_equal Okaapi.find( okaapis(:okaapi_five).id ).archived, 'false'
  end  

  test "undo archive okaapi with termcloud" do 
    session[:okaapi_mode] = 'termcloud' 
	assert_not_equal  okaapis(:okaapi_five).archived, 'false'
    get :undo_archive_okaapi
	assert_redirected_to 'http://testhost45A67/okaapi/termcloud'	
    assert_equal Okaapi.find( okaapis(:okaapi_five).id ).archived, 'false'
  end  
   
end
