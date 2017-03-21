require 'test_helper'

class AuthFilesCompareTest < ActionDispatch::IntegrationTest
  
  setup do

  end

  test "message" do
    puts "AUthFilesCOmpareTest turned off"
  end

=begin
  test "models" do
    assert FileUtils.compare_file('app/models/user.rb','../zite/app/models/user.rb')
    assert FileUtils.compare_file('app/models/user_action.rb','../zite/app/models/user_action.rb')
    assert FileUtils.compare_file('app/models/user_session.rb','../zite/app/models/user_session.rb')   
    assert FileUtils.compare_file('app/models/site_map.rb','../zite/app/models/site_map.rb')
    
    assert FileUtils.compare_file('test/models/user_test.rb','../zite/test/models/user_test.rb')
    assert FileUtils.compare_file('test/models/site_map_test.rb','../zite/test/models/site_map_test.rb')
  end
  
  test "mailers and validators" do
    assert FileUtils.compare_file('app/mailers/authentication_notifier.rb',
                                  '../zite/app/mailers/authentication_notifier.rb')
    assert FileUtils.compare_file('app/validators/email_validator.rb',
                                  '../zite/app/validators/email_validator.rb')   
    assert FileUtils.compare_file('test/mailers/authentication_notifier_test.rb',
                                  '../zite/test/mailers/authentication_notifier_test.rb')                                                                 
  end
  
  test "fixtures" do
    assert FileUtils.compare_file('test/fixtures/users.yml','../zite/test/fixtures/users.yml')
    assert FileUtils.compare_file('test/fixtures/user_actions.yml','../zite/test/fixtures/user_actions.yml')   
    assert FileUtils.compare_file('test/fixtures/user_sessions.yml','../zite/test/fixtures/user_sessions.yml')   
    assert FileUtils.compare_file('test/fixtures/site_maps.yml','../zite/test/fixtures/site_maps.yml')                                  
  end  

  test "controllers" do
    assert FileUtils.compare_file('app/controllers/admin/users_controller.rb',
                                  '../zite/app/controllers/admin/users_controller.rb')  
    assert FileUtils.compare_file('app/controllers/admin/user_sessions_controller.rb',
                                  '../zite/app/controllers/admin/user_sessions_controller.rb') 
    assert FileUtils.compare_file('app/controllers/admin/user_actions_controller.rb',
                                  '../zite/app/controllers/admin/user_actions_controller.rb')    
    assert FileUtils.compare_file('app/controllers/admin/site_maps_controller.rb',
                                  '../zite/app/controllers/admin/site_maps_controller.rb')       
                                  
    assert FileUtils.compare_file('app/controllers/authenticate_controller.rb',
                                  '../zite/app/controllers/authenticate_controller.rb')     
    assert FileUtils.compare_file('app/controllers/application_controller.rb',
                                  '../zite/app/controllers/application_controller.rb')    
                                  
    assert FileUtils.compare_file('test/controllers/users_controller_test.rb',
                                  '../zite/test/controllers/users_controller_test.rb')  
    assert FileUtils.compare_file('test/controllers/user_actions_controller_test.rb',
                                  '../zite/test/controllers/user_actions_controller_test.rb')      
    assert FileUtils.compare_file('test/controllers/user_sessions_controller_test.rb',
                                  '../zite/test/controllers/user_sessions_controller_test.rb')  
    assert FileUtils.compare_file('test/controllers/authenticate_controller_test.rb',
                                  '../zite/test/controllers/authenticate_controller_test.rb')        
    assert FileUtils.compare_file('test/controllers/site_maps_controller_test.rb',
                                  '../zite/test/controllers/site_maps_controller_test.rb')   
    assert FileUtils.compare_file('test/test_helper.rb', '../zite/test/test_helper.rb')                                     
                                                                                                                                                                                                                                                                                                                              
  end
  
  test "views" do
                                
    assert compare_directories('app/views/authenticate', '../zite/app/views/authenticate')   
    assert compare_directories('app/views/authentication_notifier', '../zite/app/views/authentication_notifier')       

    assert compare_directories('app/views/admin/users', '../zite/app/views/admin/users') 
    assert compare_directories('app/views/admin/user_sessions', '../zite/app/views/admin/user_sessions')   
    assert compare_directories('app/views/admin/user_actions', '../zite/app/views/admin/user_actions') 
    assert compare_directories('app/views/admin/site_maps', '../zite/app/views/admin/site_maps') 
                                                 
  end
  
  test "integration" do
    assert FileUtils.compare_file('test/integration/auth_user_stories_test.rb', 
                                  '../zite/test/integration/auth_user_stories_test.rb')                                                                                                                                                                                                                                                                                                                                                                   
  end  
  
  test "migrations" do
    assert FileUtils.compare_file('db/migrate/20141106192626_create_users.rb',
                                  '../zite/db/migrate/20141106192626_create_users.rb')  
    assert FileUtils.compare_file('db/migrate/20141106192627_create_user_sessions.rb',
                                  '../zite/db/migrate/20141106192627_create_user_sessions.rb')  
    assert FileUtils.compare_file('db/migrate/20141106192628_create_user_actions.rb',
                                  '../zite/db/migrate/20141106192628_create_user_actions.rb')                                                                      
    assert FileUtils.compare_file('db/migrate/20150715210233_add_site_to_users.rb',
                                  '../zite/db/migrate/20150715210233_add_site_to_users.rb')  
    assert FileUtils.compare_file('db/migrate/20150715210246_add_site_to_user_sessions.rb',
                                  '../zite/db/migrate/20150715210246_add_site_to_user_sessions.rb')  
    assert FileUtils.compare_file('db/migrate/20150715210318_add_site_to_user_actions.rb',
                                  '../zite/db/migrate/20150715210318_add_site_to_user_actions.rb') 
    assert FileUtils.compare_file('db/migrate/20150723195726_create_site_maps.rb',
                                  '../zite/db/migrate/20150723195726_create_site_maps.rb')  
  end

  test "yaml" do
    assert FileUtils.compare_file('config/auth_mail.yml','../zite/config/auth_mail.yml')
  end
  
  test "assets" do
    assert file_diff('app/assets/stylesheets/application.scss',
                      '../zite/app/assets/stylesheets/application.scss'), "@import \"okaapi\";\n"
  end  
  
  private
  
  def compare_directories( d1, d2 )
    files = Dir.entries( d1 )
    files.each do |f|
      if f != '.' and f != '..'
        f1 = d1 + '/' + f
        f2 = d2 + '/' + f    
        if ! FileUtils.compare_file( f1, f2 )
          puts "#{f1} IS NOT #{f2}"
          return false
        end
      end
    end
    return true
  end
  
  def file_diff( f1, f2 )
    lines1 = lines2 = nil
    File.open(f1) { |f| lines1 = f.readlines }
    File.open(f2) { |f| lines2 = f.readlines }
    diff_string = ''
    lines1.each_with_index do |c,i|
      if lines1[i] != lines2[i]
        diff_string += lines1[i]
      end
    end
    return diff_string
  end
  
=end
  
end
