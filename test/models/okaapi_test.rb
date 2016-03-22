require 'test_helper'
require 'pp'

class OkaapiTest < ActiveSupport::TestCase
  
  setup do
    @user_arnaud = users( :arnaud )
    @user_francois = users( :francois )
    Okaapi.all.each do |w|
      w.user_id = @user_arnaud.id
      w.save!
    end    
    okaapis = Okaapi.unarchived_for_user( @user_arnaud.id )
    terms = Okaapi.terms( okaapis )      
    terms = Word.unarchived_terms_not_person_for_user( @user_arnaud.id, terms )
    w = Word.where( id: terms['peter'][:word_id] ).where( user_id: @user_arnaud.id ).first
    w.person = 'true'
    w.save!
    w = Word.where( id: terms['john'][:word_id] ).where( user_id: @user_arnaud.id ).first
    w.person = 'true'
    w.save!   
     
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
  
  test "terms" do
    okaapis = Okaapi.unarchived_for_user( @user_arnaud.id )
    terms = Okaapi.terms( okaapis )
    assert_equal terms.count, 10
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

#
#  Okaapis:    red green violet
#              red blue purple
#              yellow gray petrol
# 
#    red => [ [blue], [purple], [red], [green], [violet] ]
#    yellow => [ [gray], [yellow], [petrol] ]
#
#  filtered by red
#    blue => [ [blue], [purple] ]    
#    green => [ [green], [violet] ]
#

  test "mindmap" do
    mindmap = Okaapi.mindmap( @user_arnaud.id )
    assert_equal mindmap.count, 2
   
    assert mindmap['red']
    assert mindmap['gray']
  end
  
  test "mindmap with limits" do
    mindmap = Okaapi.mindmap( @user_arnaud.id, ['red'] )
    assert_equal mindmap.count, 2

    assert mindmap['blue']
    assert mindmap['green']
  end  
  
end
