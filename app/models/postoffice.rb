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

  def self.send_okaapi_emails
    n = 0
    users = User.all
    users.each do |user|
      okaapis = Okaapi.where( user_id: user.id ).where( archived: false )
      if okaapis.count > 0
        puts "sending email to #{user.email} (this is a test....)"
        OkaapiMailer.send_okaapi_reminder( user.email, "this is a test please send to wido", okaapis ).deliver
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
        puts "sending email to #{user.email} (#{user.goal_in_subject})"
        DiaryReminder.send_diary_reminder( user.email, user.goal_in_subject, Time.now, token ).deliver
    n = n + 1
      end
    end  
    return n
  end
  
end
