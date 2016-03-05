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

      puts "sending email to #{user.email}"

      @persons = Word.unarchived_people( user.id )
      @people = []
      @persons.each do |person|
        okaapis = Okaapi.for_person( user.id, person.term )
        @people << [ person, okaapis ] if okaapis.size > 0
      end
      @people.sort! { |a,b| a[0].term <=> b[0].term } 

      okaapis = Okaapi.unarchived_for_user( user.id )
      terms = Okaapi.terms( okaapis )      
      terms = Word.unarchived_terms_not_person_for_user( user.id, terms )|| {}
      @prio_okaapis = []
      terms.each do |k,v|
        if v[:priority].to_int > 1
          @prio_okaapis += Okaapi.for_term( user.id, k )
        end
      end

      if @prio_okaapis.count > 0
        OkaapiMailer.send_okaapi_reminder( user.email, "Okaapi Reminder", 
             @people, @prio_okaapis ).deliver
        if( user.alternate_email )
          OkaapiMailer.send_okaapi_reminder( user.alternate_email, 
	  	"Okaapi Reminder", 
               @people, @prio_okaapis ).deliver 
        end
      end
      n = n + 1
    end
    return n
  end

=begin
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
=end

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
