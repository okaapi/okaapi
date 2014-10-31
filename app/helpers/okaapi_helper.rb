module OkaapiHelper
  
  def term_size( f )
    
    if f <= 1
      "1"
    elsif f <= 2
      "2"
    elsif f <= 5
      "3"
    elsif f <= 10
      "4"
    else
      "5"
    end
 
  end
  
  def term_color( p )
    
    if p < 1
      "1"
    elsif p < 2
      "2"
    else
      "3"
    end
 
  end  
  
end
