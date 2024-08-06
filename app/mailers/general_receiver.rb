require 'net/pop'
class GeneralReceiver < ActionMailer::Base

  
  # this gets executed once when the class is initialized
  #
  # we use okaapi_mail assuming that it includes the same info as diary_mail.yml
  # for receiving
  #
  mail_config = (YAML::load( File.open(Rails.root + 'config/okaapi_mail.yml') ))
  self.smtp_settings = mail_config["server"].merge(mail_config["credentials"])
      .merge(mail_config["pop"]).symbolize_keys

  # 
  # receives both diary entries and okaapis
  # the difference is that diary entries include #whatdidyoudo
  #
  def self.get_entries
  
    okaapis = []
    diary_entries = []

    #
    #  pop version
    #
    #pop = Net::POP3.new smtp_settings[:pop_server]
    #pop.enable_ssl
    #pop.start smtp_settings[:user_name], smtp_settings[:password]
    #pop.each_mail do |message|
    #  message_obj = Mail.new(message.pop) 

    pop_server = smtp_settings[:pop_server]
    user_name = smtp_settings[:user_name]
    password = smtp_settings[:password]
    Mail.defaults do
      retriever_method :pop3, :address    => pop_server,
                          :port       => 995,
                          :user_name  => user_name,
                          :password   => password,
                          :enable_ssl => true
    end

    mails = Mail.all
    p mails.count
    
    mails.each do |message_obj|
      from = message_obj.from
      subj = message_obj.subject
      tmsg = message_obj.date
      if message_obj.multipart?
        if message_obj.text_part
          body = message_obj.text_part.body.decoded
        end
      else
        body = message_obj.decoded
      end

      #
      #  diary entries - if #whatdidyoudo is on the subject line
      #
      if subj.include?( "#whatdidyoudo" )

        t_subj = Time.parse( subj ) rescue Time.now
        if body.include?('2023')
          t_subj = t_subj - 1.year
        end
        puts subj
        puts t_subj
                 
        entry = { day: t_subj.day, month: t_subj.month, year: t_subj.year, date: t_subj, from: from }   
      
        body.gsub!(/\n/,"")
        body.gsub!(/\r/,"")
        body.gsub!(/On(?:(?!On).)*?wrote:/m, '')
        body.gsub!(/Am(?:(?!Am).)*?>:/m, '')
        body.squeeze!('>')
        body.gsub!(/<>/, '')
        body.gsub!(/> >/, '>')
        body.gsub!(/^\s*>/,'')
        body.gsub!(/>$/,'')
        body.strip!

        entry[:content] = body || "" 
      
        diary_entries << entry


      #
      #   okaapis
      #
      else # message subject does not include #whatdidyoudo

        r = subj.split("#")
        subj = r[0]
        t_r = Time.parse(r[1..-1].join("#")) rescue Time.now
        # if t_r is very close to "now", assume there is no reminder specified... remind tomorrow
        if (Time.now - t_r).to_i.abs < 3
          t_r = (tmsg.utc + 1 ).to_s
        else
          t_r = t_r.utc.to_s
        end        
      
        entry = { time: t, from: from, content: ( body || "" ),
                  subject: subj, reminder: t_r }    
            
        okaapis << entry

      end

      # pop
      # message.delete
      message_obj.mark_for_delete = true
      Mail.find_and_delete

    end 
      
    # pop
    # pop.finish
    
    return okaapis, diary_entries

  end

end
