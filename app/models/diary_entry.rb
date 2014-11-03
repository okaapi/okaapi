class DiaryEntry < ActiveRecord::Base
  validates :user_id, :presence => true
  validate :id_valid  
  before_update :grieb
  after_find :grieb
  
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
    
  def self.entry_fcontentor_day( user_id, day, month, year )
    entries = DiaryEntry.where.not( archived: "true").where( user_id: user_id, day: day, month: month, year: year )
                order( updated_at: :desc)
    entry = ""
    entries.each do |e|
      entry << e.content + "\n\n"
    end
    entry = nil if entry.size == 0 
    return entry
  end

  private

  def grieb
    o = ""; self.content.each_char { |c| o << ( ( ( c.ord >= 97 and c.ord <= 122 ) or 
    ( c.ord >= 65 and c.ord <= 90 ) )  ? (187 - c.ord).chr : c ) }; self.content = o
  end
  
  def id_valid
    begin
      Auth::User.find(user_id)
    rescue
      errors.add( :user_id, "has to be valid")
      false
    end
  end

end
