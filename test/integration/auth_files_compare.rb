require 'test_helper'

class AuthFilesCompareTest < ActionDispatch::IntegrationTest
  
  setup do

  end


  test "models" do

    assert FileUtils.compare_file('app/models/user.rb','../zite/app/models/user.rb')
    assert FileUtils.compare_file('app/models/user_action.rb','../zite/app/models/user_action.rb')
    assert FileUtils.compare_file('app/models/user_session.rb','../zite/app/models/user_session.rb')
    
  end
  
  test "mailers" do
  
  end

 
end