require 'test_helper'

class OkaapiMailerTest < ActionMailer::TestCase
  
  test "send_reminder" do
    mail = OkaapiMailer.send_okaapi_reminder( "wido@menhardt.com", "some subject" )
  end

end
