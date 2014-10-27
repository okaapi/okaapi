module DiaryHelper
  
  def weekday( month, day, year )
    begin
      Time.parse( "#{day}-#{month}-#{year}").strftime("%A")
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
  
  def content_for_day( user_id, month, day, year )
    DiaryEntry.entry_for_day( user_id, day, month, year )
  end
  
end
