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
  
end
