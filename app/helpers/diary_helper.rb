module DiaryHelper
  
  def weekday( month, day, year )
    begin
      Time.parse( "#{day}-#{month}-#{year}").strftime("%A")[0..2]
    rescue
      ""
    end
  end
  
  def monthname( month )
    begin
      Date::MONTHNAMES[ month.to_i ]
    rescue
      ""
    end  
  end

  def tag_color_helper( colors, index )
    colors[index.modulo( colors.size )]    
  end
  
  def substitute_tag_and_color_helper( entry, tags, colors )
    if entry
      
      # #keyword xxx yyy## -> xxx yyy; 
      tags.each_with_index do |tag,i|
        entry = entry.gsub(/##{tag}((?:(?!#).)*?)\s*?##/mi, "<span style='color:#{colors[i]}'>" + '\1' + "</span>")
      end
      
      ##      # remove all #..## occurances
	  ##      entry = entry.gsub(/#(?:(?!#).)*?##/mi, '')	  

      # #keyword xxx  -> xxx; 
      tags.each_with_index do |tag,i|
        entry = entry.gsub(/##{tag}\s+?(\S*)/, "<span style='color:#{colors[i]}'>" + '\1' + "</span>")
      end      

	  # compact all white spaces!
      entry.squish.strip
	else
	  ''
	end  
  end
  
end
