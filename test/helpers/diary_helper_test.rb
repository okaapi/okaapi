require 'test_helper'

class DiaryHelperTest < ActionView::TestCase

 test "hash substitution do" do

   entry = " #dr bla bla #sports bli #travel arb berb ## #xil xal xul ## "
   tags = ['dr','sports', 'travel', 'xil']
   colors = ['green','blue','red']
   s = substitute_tag_and_color_helper( entry, tags, colors )
   assert_equal( s, "<span style='color:green'>dr: bla</span> bla <span style='color:blue'>sports: bli</span> <span style='color:red'> travel: arb berb</span> <span style='color:'> xil: xal xul</span>")
   
   entry = "#dr bla bla #sports bli #travel arb berb ## #xil xal xul ##"
   tags = ['dr','sports', 'travel', 'xil']
   colors = ['green','blue','red']
   s = substitute_tag_and_color_helper( entry, tags, colors )
   assert_equal( s, "<span style='color:green'>dr: bla</span> bla <span style='color:blue'>sports: bli</span> <span style='color:red'> travel: arb berb</span> <span style='color:'> xil: xal xul</span>")
   
   entry = "#dr ##"
   tags = ['dr']
   colors = ['green']
   s = substitute_tag_and_color_helper( entry, tags, colors )
   assert_equal( s, "<span style='color:green'> dr: </span>")
   
   entry = "#dr bla"
   tags = ['dr']
   colors = ['green']
   s = substitute_tag_and_color_helper( entry, tags, colors )
   assert_equal( s, "<span style='color:green'>dr: bla</span>")
   
   entry = "#dr "
   tags = ['dr']
   colors = ['green']
   s = substitute_tag_and_color_helper( entry, tags, colors )
   assert_equal( s, "<span style='color:green'>dr: </span>")   
      
   entry = "#dr"
   tags = ['dr']
   colors = ['green']
   s = substitute_tag_and_color_helper( entry, tags, colors )
   assert_equal( s, "#dr")    
               
   entry = "#dr XX"
   tags = ['dr']
   colors = ['green']
   s = substitute_tag_and_color_helper( entry, tags, colors )
   assert_equal( s, "<span style='color:green'>dr: XX</span>")    
               
   entry = "#dr ##"
   tags = ['dr']
   colors = ['green']
   s = substitute_tag_and_color_helper( entry, tags, colors )
   assert_equal( s, "<span style='color:green'> dr: </span>")   
              
   entry = "#dr##"
   tags = ['dr']
   colors = ['green']
   s = substitute_tag_and_color_helper( entry, tags, colors )
   assert_equal( s, "<span style='color:green'> dr: </span>")  
         
 end
   
end
