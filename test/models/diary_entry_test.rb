require 'test_helper'

class DiaryEntryTest < ActiveSupport::TestCase
  
  setup do
    ZiteActiveRecord.site( 'testsite45A67' )
  end
  
  test "hash substitution" do
  
    s = DiaryEntry.nohash(" #dr bla bla #sports bli #travel arb berb ## #xil xal xul ## ")
	assert_equal( s, "dr: bla; bla sports: bli; travel: arb berb; xil: xal xul;" )
 
    s = DiaryEntry.nohash("#dr bla bla #sports bli #travel arb berb ## #xil xal xul ##")
	assert_equal( s, "dr: bla; bla sports: bli; travel: arb berb; xil: xal xul;" )
	
	s = DiaryEntry.nohash("#dr ##")
	assert_equal( s, "dr: ;" )
	
	s = DiaryEntry.nohash("#dr bla")
	assert_equal( s, "dr: bla;" )
	
	s = DiaryEntry.nohash("#dr ")
	assert_equal( s, "dr: ;" )	
	
	# we don't handle this case... makes no sense anyway
	s = DiaryEntry.nohash("#dr")
	assert_equal( s, "#dr" )	
	
	s = DiaryEntry.nohash("#dr ##")
	assert_equal( s, "dr: ;" )		
	
	# we don't handle this case... makes no sense anyway
	s = DiaryEntry.nohash("#dr##")
	assert_equal( s, "" )	
	
  end
  
  test "tag extraction" do
  
    t = DiaryEntry.tags(" #dr bla bla #sports bli #travel arb berb ## #xil xal xul ## ")
	assert_equal t, [["travel", "arb berb"], ["xil", "xal xul"], ["dr", "bla"], ["sports", "bli"]]
 
    t = DiaryEntry.tags("#dr bla bla #sports bli #travel arb berb ## #xil xal xul ##")
	assert_equal t, [["travel", "arb berb"], ["xil", "xal xul"], ["dr", "bla"], ["sports", "bli"]]

	t = DiaryEntry.tags("#dr ##")
	assert_equal t, [["dr", ""]]
	
	t = DiaryEntry.tags("#dr bla")
	assert_equal t, [["dr", "bla"]]
	
	t = DiaryEntry.tags("#dr ")
	assert_equal t, [["dr", ""]]
	
	# we don't handle this case... makes no sense anyway
	t = DiaryEntry.tags("#dr")
	assert_equal t, []
	
	t = DiaryEntry.tags("#dr ##")
	assert_equal t, [["dr", ""]]	
	
	# we don't handle this case... makes no sense anyway
	t = DiaryEntry.tags("#dr##")
	assert_equal t, []
	
  end  
  
end
