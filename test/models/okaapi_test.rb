require 'test_helper'

class OkaapiTest < ActiveSupport::TestCase
  
  setup do
    @user_arnaud = Auth::User.new( username: 'arnaud', email: 'arnaud@gmail.com', 
                               active: 'confirmed',
                               password: 'secret', password_confirmation: 'secret')
    @user_arnaud.save!  
    @user_francois = Auth::User.new( username: 'francois', email: 'francois@gmail.com',
                               password: 'secret', password_confirmation: 'secret',
                               token: 'francois_token' )
    @user_francois.save!        
    Okaapi.all.each do |w|
      w.user_id = @user_arnaud.id
      w.save!
    end
    o = okaapis( :okaapi_four )
    o.user_id = @user_francois.id
    o.save!
    o = okaapis( :okaapi_five )
    o.user_id = @user_francois.id
    o.save!    
  end
  
  test "unarchived for user" do
    okaapis = Okaapi.unarchived_for_user( @user_arnaud.id )
    assert_equal okaapis.count, 3
  end
  
  test "terms for user" do
    okaapis = Okaapi.terms_for_user( @user_arnaud.id )
    assert_equal okaapis.count, 7
    o = Word.find_by_term('purple')
    assert_not_equal o.archived, 'false'
  end 
  
  test "for term" do
    okaapis = Okaapi.for_term( @user_arnaud.id, 'red' )
    assert_equal okaapis.count, 2
  end

  test "for person" do
    john = okaapis(:okaapi_five)
    john.archived = 'false'
    john.save!
    john = okaapis(:okaapi_four)
    john.archived = 'false'    
    john.save!
    okaapis = Okaapi.for_person( @user_francois.id, 'john' )
    assert_equal okaapis.count, 1 
  end
  
  test "last archived" do
    john = okaapis(:okaapi_five)
    john.archived = Time.now() + 1
    john.save!
    john = okaapis(:okaapi_four)
    john.archived = Time.now
    john.save!   
    last = Okaapi.find_last_archived( @user_francois.id )
  end

  
end
