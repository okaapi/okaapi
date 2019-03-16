require 'test_helper'

#class DummyDiaryDeliverer
#  def deliver
#  end
#end

class DiaryReceiver
  def self.get_diary_entries
    entries = []
    entries << { day: 1, month: 3, year: 2015, date: Time.parse('15/3/1'), 
            from: 'wido@mmm.com', content: "day 1"}
    entries << { day: 2, month: 3, year: 2015, date: Time.parse('15/3/2'), 
            from: 'john_alternate@menhardt.com', content: "day 2"}
    entries << { day: 3, month: 3, year: 2015, date: Time.parse('15/3/3'), 
            from: 'arnaud@gmail.com', content: "day 3"}
    entries                    
  end
  #def self.send_diary_reminder( email, goal, time )
  #  DummyDiaryDeliverer.new
  #end
end

class DiaryControllerTest < ActionController::TestCase
  
  setup do
	ZiteActiveRecord.site( 'testsite45A67' )
    request.host = 'testhost45A67'	     
    login_4_test 
    DiaryEntry.all.each do |o|
      o.user_id = @current_user.id
      o.save!
    end 
  end

  test "when not logged in" do
    # we're logged in so we need to clear that
    session[:user_session_id] = nil
    get :calendar
    assert_response :success  
  end
  
  test "receive diary entries" do 
    @request.env['HTTP_REFERER'] = 'http://testhost45A67/'
    # wido@menhardt.com and john@menhardt.com are known users, so they get added,
    # but arnaud@gmail.com is ignored...
    
    assert_difference('DiaryEntry.count', +2) do
      get :receive_diary_emails
      assert_equal flash[:notice], "received 2 diary emails"
      assert_redirected_to calendar_path
    end
    
  end
  
  test "turn diary service on" do
    @request.env['HTTP_REFERER'] = 'http://testhost45A67/'
    
    assert_equal  @current_user.diary_service, "off"
    post :send_diary_email
    assert_equal  User.find_by_username('arnaud').diary_service, "on"
    assert_redirected_to calendar_path   
  end
  
  test "turn diary service off" do
    @request.env['HTTP_REFERER'] = 'http://testhost45A67/'
    
    @current_user.diary_service = "on"
    @current_user.save!(validate: false)
    assert_equal  @current_user.diary_service, "on"
    post :turn_off_diary_emails
    assert_equal  User.find_by_username('arnaud').diary_service, "off"
    assert_redirected_to calendar_path    
  end  
  
  test "display March 2015" do
    
    get :calendar
    assert_response :success    
    assert_not_nil assigns(:current_user)
    assert_not_nil assigns(:calendar)
    assert_equal assigns(:calendar).size, 6
    assert_equal assigns(:calendar)[1].count, 7
    assert_equal assigns(:month), 3
    assert_equal assigns(:year), 2015
    assert_equal assigns(:calendar)[1][7][:day], 1
  end
  
  test "display November 2014" do
    
    get :calendar, params: { month: 11, year: 2014 }
    assert_response :success  
    assert_equal assigns(:calendar)[1][7][:day], 2
  end
  
  test "display November 2021" do
    
    get :calendar, params: { month: 9, year: 2014 }
    assert_response :success  
    assert_equal assigns(:calendar)[1][7][:day], 7
  end
  
end
