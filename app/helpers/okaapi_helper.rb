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
    
    if !p
      "1"
    elsif p < 1
      "1"
    elsif p < 2
      "2"
    else
      "3"
    end
 
  end  
  
  def side( a ) 
    Math.sqrt( a.size / 2 ).to_i + 1
  end
  
  def graph_tooltip( word_id )
    @word = Word.find_by_id( word_id )   
    @okaapis = Okaapi.for_term( @current_user.id, @word.term )
    str = ''
    @okaapis.each do |okaapi|
      str << okaapi[:subject] + '<br>'
    end
    str
  end
  
  def okaapi_mode
    session[:okaapi_mode] || 'mindmap'
  end
  
end
