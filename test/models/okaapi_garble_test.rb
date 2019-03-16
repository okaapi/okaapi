require 'test_helper'
require 'pp'

class OkaapiGarbleTest < ActiveSupport::TestCase
  
  setup do
    ZiteActiveRecord.site( 'testsite45A67' )   
  end
  
  test "okaapi verify garbled new okaapi on save" do
    okap = Okaapi.create( user_id: users(:john).id, subject: 'red green blue' ) 	
	okap_id = okap.id
	# verify it's not garbled yet
	assert_equal okap.subject, 'red green blue'
	assert okap.save
    # verify that it's garbled in the database, but not in the object
	res = ActiveRecord::Base.connection.execute("select subject from okaapis where id = #{okap_id}")
	assert_equal res.first[0], 'IVW TIVVM YOFV'	
	assert_equal okap.subject, 'red green blue'
    # verify that it's not garbled upon retrieval, but still gabled in the database
	okap2 = Okaapi.find( okap_id )
	res = ActiveRecord::Base.connection.execute("select subject from okaapis where id = #{okap_id}")	
	assert_equal res.first[0], 'IVW TIVVM YOFV'	
	assert_equal okap2.subject, 'red green blue'	
  end
  
  test "okaapi verify garbled existing non-garbled fixture okaapi on access" do  
	# verify fixture is not garbled yet
	res = ActiveRecord::Base.connection.execute(
	                   'select subject from okaapis where subject = "yellow gray petrol" ' )
	assert_equal res.first[0], 'yellow gray petrol'
    okap = okaapis(:okaapi_three)	
	okap.user_id = users(:john).id
	okap.save!
	res = ActiveRecord::Base.connection.execute(
	                   'select subject from okaapis where subject = "BVOOLD TIZB KVGILO" ' )
	assert_equal res.first[0], 'BVOOLD TIZB KVGILO'		
  end
  
  test "okaapi verify garbled existing non-garbled fixture okaapi w/o g-flag on access" do  
	# verify fixture is not garbled yet
	res = ActiveRecord::Base.connection.execute(
	                   'select subject from okaapis where subject = "fox hen deer" ' )
	assert_equal res.first[0], 'fox hen deer'	
    okap = okaapis(:okaapi_four)	
	okap.user_id = users(:john).id
	okap.save!
	res = ActiveRecord::Base.connection.execute(
	                   'select subject from okaapis where subject = "ULC SVM WVVI" ' )
	assert_equal res.first[0], 'ULC SVM WVVI'	
  end
 
  
end
