require 'test_helper'

class DummyDiaryDeliverer
  def deliver
  end
end

class DiaryReminder < ActionMailer::Base
  def self.get_diary_entries
    entries = []
    entries << { day: 1, month: 3, year: 2015, date: Time.parse('15/3/1'), 
            from: 'wido@menhardt.com', content: "day 1"}
    entries << { day: 2, month: 3, year: 2015, date: Time.parse('15/3/2'), 
            from: 'john_alternate@menhardt.com', content: "day 2"}
    entries << { day: 3, month: 3, year: 2015, date: Time.parse('15/3/3'), 
            from: 'arnaud@gmail.com', content: "day 3"}
    entries                    
  end
  def self.send_diary_reminder( email, time )
    DummyDiaryDeliverer.new
  end
end

class DiaryControllerTest < ActionController::TestCase
  
  setup do
    @wido = User.find_by_username('wido')
    @user_session = UserSession.find_by_client('MyClient')
    @user_session.user_id = @wido.id
    @user_session.save!
    @current_user = @user_session.user 
    DiaryEntry.all.each do |o|
      o.user_id = @wido.id
      o.save!
    end 
  end
  
  def login
    @controller.session[:user_session_id] = @user_session.id
  end

  test "receive diary entries" do 
    @request.env['HTTP_REFERER'] = 'http://test.host/'
    # wido@menhardt.com and john@menhardt.com are known users, so they get added,
    # but arnaud@gmail.com is ignored...
    
    assert_difference('DiaryEntry.count', +2) do
      get :receive_diary_emails
      assert_redirected_to root_path
    end
    
  end
  
  test "turn diary service on" do
    @request.env['HTTP_REFERER'] = 'http://test.host/'
    login
    assert_equal  @wido.diary_service, "off"
    post :send_diary_email
    assert_equal  User.find_by_username('wido').diary_service, "on"
    assert_redirected_to root_path    
  end
  
  test "turn diary service off" do
    @request.env['HTTP_REFERER'] = 'http://test.host/'
    login
    @wido.diary_service = "on"
    @wido.save!(validate: false)
    assert_equal  @wido.diary_service, "on"
    post :turn_off_diary_emails
    assert_equal  User.find_by_username('wido').diary_service, "off"
    assert_redirected_to root_path    
  end  
  
  test "display March 2015" do
    login
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
    login
    get :calendar, month: 11, year: 2014
    assert_response :success  
    assert_equal assigns(:calendar)[1][7][:day], 2
  end
  
  test "display November 2021" do
    login
    get :calendar, month: 9, year: 2014
    assert_response :success  
    assert_equal assigns(:calendar)[1][7][:day], 7
  end
  
end
