require 'net/http'

class Postoffice

  def self.send_okaapi_emails
    n = 0
    users = User.where( active: 'confirmed' )
    users.each do |user|

      puts "sending email to #{user.email}"

      @tides = Tides.get_santa_cruz_tides

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
             @tides, @people, @prio_okaapis ).deliver_now
        if( user.alternate_email )
          OkaapiMailer.send_okaapi_reminder( user.alternate_email, 
	  	"Okaapi Reminder", 
               @tides, @people, @prio_okaapis ).deliver_now
        end
      end
      n = n + 1
    end
    return n
  end

  def self.send_all_diary_emails( token )    
    n = 0
    if token
      users = User.where( diary_service: "on")
      users.each do |user|
        puts "sending email to #{user.email} (#{user.goal_in_subject})"
        DiaryReminder.send_diary_reminder( user.email, user.goal_in_subject, Time.now, token ).deliver_now
        n = n + 1
      end
    end  
    return n
  end
  
  def self.receive_okaapi_and_diary_emails

    new_okaapis, new_diary_entries = GeneralReceiver.get_entries
    n_d = 0
    new_diary_entries.each do |entry|
      if user = User.by_email_or_alternate( entry[:from] )
        entry[:user_id] = user.id
        de = DiaryEntry.create( entry )
          de.save!
          n_d = n_d + 1
      end
    end

    n_o = 0
    new_okaapis.each do |entry|
      if user = User.by_email_or_alternate( entry[:from] )
        ok = Okaapi.new( entry )
        ok.user_id = user.id
        begin
          ok.save!
        rescue
          ok.content = 'content erased'
          ok.save!
        end
        n_o = n_o + 1
      end
    end

    return n_o, n_d

  end
    
end
