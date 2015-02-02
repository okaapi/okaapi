require 'test_helper'

class WordTest < ActiveSupport::TestCase
  
  setup do
    @user_arnaud = Auth::User.new( username: 'arnaud', email: 'arnaud@gmail.com', 
                                 active: 'confirmed',
                                 password: 'secret', password_confirmation: 'secret')
    @user_arnaud.save!  
    @user_francois = Auth::User.new( username: 'francois', email: 'francois@gmail.com',
                                 password: 'secret', password_confirmation: 'secret',
                                 token: 'francois_token' )
    @user_francois.save!        
    Word.all.each do |w|
      w.user_id = @user_arnaud.id
      w.save!
    end
    
    word = Word.find_by_term('archived_earlier')
    word.user_id =  @user_francois.id 
    word.save!
    word = Word.find_by_term('archived_last')
    word.user_id =  @user_francois.id 
    word.save!        
    words = Word.all
    #words.each {|w| puts w.term + ' ' + w.archived + ' ' + w.person }    
  end
  
  test "the truth" do
    words = Word.unarchived_terms_not_person_for_user( @user_arnaud.id, 
        ['blue','green','purple','petrol'] )
    assert_equal words.count, 3
    assert words['blue']
    assert words['green']
    assert words['petrol']
    assert ! words['purple']
    assert_equal Word.count, 10
      
    blue = Word.find_by_term( 'blue')
    blue.user_id = @user_francois.id
    blue.save!
    words = Word.unarchived_terms_not_person_for_user( @user_francois.id, 
        ['blue','green','purple','petrol'] )
    assert_equal words.count, 4
    assert words['blue']
    assert words['green']
    assert words['petrol']
    assert words['purple']
    assert_equal Word.count, 13

  end
  
  test "unarchived people" do
    words = Word.unarchived_people( @user_arnaud.id)
    #words.each {|w| p w}
    assert words.count, 2
    assert_not_nil words.find_by_term('john').term
    assert_not_nil words.find_by_term('peter').term
    assert_nil words.find_by_term('gale')
  end
  
  test "last archived" do

    word = Word.find_last_archived( @user_francois.id )
    assert_equal word.term, 'archived_last'
  end
  
end
