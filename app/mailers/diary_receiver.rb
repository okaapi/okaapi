class DiaryReceiver
  
  # this gets executed once when the class is initialized
  mail_config = (YAML::load( File.open(Rails.root + 'config/diary_mail.yml') ))
  @@smtp_settings = mail_config["server"].merge(mail_config["credentials"])
      .merge(mail_config["pop"]).symbolize_keys
  
  # 
  #  yeah, so we're using smtp_settings also for pop
  #
  def self.get_diary_entries

    pop_server = @@smtp_settings[:pop_server]
    user_name = @@smtp_settings[:user_name]
    password = @@smtp_settings[:password]
    Mail.defaults do
      retriever_method :pop3, :address    => pop_server,
                          :port       => 995,
                          :user_name  => user_name,
                          :password   => password,
                          :enable_ssl => true
    end

    entries = []
    marray = Mail.all
    marray.each do |message|
    
      from = message.from[0]
      subject = message.subject
      puts "++++++++++++++++++++++++++++++"
      puts subject
      if message.multipart? 
        if message.text_part
          body = message.text_part.body
        else
          body = "multipart but no text_part"
        end
      else 
        body = message.body.decoded
      end
      puts body
       
      body = message.body.decoded
            
      t = Time.parse( subject ) rescue Time.now
      entry = { day: t.day, month: t.month, year: t.year, date: t, from: from }   
      
      #
      #  remove
      #       On Tuesday, March 22, 2016, Automatic Diary <automaticdiary@gmail.com> wrote:
      # 
      body.gsub!(/On(?:(?!On).)*?wrote:/m, '')
      
      #
      #  remove
      #         From: Automatic Diary [mailto:automaticdiary@gmail.com] 
      #         Sent: Friday, March 25, 2016 6:00 PM
      #         To: wido@menhardt.com
      #         Subject: What did you do on Friday 25 March ?
      #
      body.gsub!( /(From: Automatic Diary.*?\?)?/m ,'' )
      
      body.gsub!(/\n>/, '')      
      entry[:content] = body || "" 
            
      entries << entry

    end 
  
    return entries
  end

end
