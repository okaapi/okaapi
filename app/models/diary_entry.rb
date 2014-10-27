class DiaryEntry < ActiveRecord::Base
  
  def self.last_entry( user_id )
    # first get the last day
    entries = DiaryEntry.where.not( archived: "true").where( user_id: user_id ).
                order( year: :desc ).order( month: :desc).order( day: :desc )
    if entries.size > 0
      return entries[0].day, entries[0].month, entries[0].year
    else
      return Time.now.day, Time.now.month, Time.now.year
    end
  end
    
  def self.entry_for_day( user_id, day, month, year )
    entries = DiaryEntry.where.not( archived: "true").where( user_id: user_id, day: day, month: month, year: year )
                order( updated_at: :desc)
    entry = ""
    entries.each do |e|
      entry << e.content + "\n\n"
    end
    entry = nil if entry.size == 0 
    return entry
  end
  
end
