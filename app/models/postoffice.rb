class Postoffice

  def self.receive_okaapi_emails  
    new_entries = OkaapiMailer.get_okaapis
    n = 0
    new_entries.each do |entry|
      if user = User.find_by_email_or_alternate( entry[:from] )
        ok = Okaapi.new( entry )
        ok.user_id = user.id
        ok.save!
         n = n + 1
      end
    end
    return n
  end
  
  def self.receive_diary_emails    
    new_entries = DiaryReminder.get_diary_entries 
    n = 0
    new_entries.each do |entry|
      if user = User.find_by_email_or_alternate( entry[:from] )
        entry[:user_id] = user.id
        de = DiaryEntry.create( entry )
         de.save!
         n = n + 1
      end
    end
    return n
  end
  
  def self.send_all_diary_emails( token )    
    n = 0
    if token
      users = User.where( diary_service: "on")
      users.each do |user|
        DiaryReminder.send_diary_reminder( user.email, Time.now, token ).deliver
    n = n + 1
      end
    end  
    return n
  end
  
end
