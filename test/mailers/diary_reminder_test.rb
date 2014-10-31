require 'test_helper'

class DiaryReminderTest < ActionMailer::TestCase
  
  test "send_reminder" do
    mail = DiaryReminder.send_diary_reminder( "wido@menhardt.com" )
  end

end
