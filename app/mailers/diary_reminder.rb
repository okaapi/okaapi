require 'net/pop'
class DiaryReminder < ActionMailer::Base

  
  # this gets executed once when the class is initialized
  mail_config = (YAML::load( File.open(Rails.root + 'config/diary_mail.yml') ))
  self.smtp_settings = mail_config["server"].merge(mail_config["credentials"])
      .merge(mail_config["pop"]).symbolize_keys
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_reminder.send_reminder.subject
  #
  def send_diary_reminder( user_email, user_goal, date = Time.now, token = nil )
    subj = 'What did you do on ' + Date::DAYNAMES[ date.wday] +  
            date.strftime(" %d ") + 
             Date::MONTHNAMES[ Time.now.month ] + user_goal + " ?"   
    if !token or token.to_s == smtp_settings[:token].to_s
      mail from: smtp_settings[:sender_email], to: user_email, subject: subj
    end
  end

  #
  #
  #
  def test( user_email )
    mail from: smtp_settings[:sender_email], to: user_email
  end
      
  # 
  #  yeah, so we're using smtp_settings also for pop
  #
  def get_diary_entries
  
    pop = Net::POP3.new smtp_settings[:pop_server]
    pop.enable_ssl
    pop.start smtp_settings[:user_name], smtp_settings[:password]
      
    entries = []
    pop.each_mail do |message|

      from, subject, body = receive( message.pop )
      
      t = Time.parse( subject ) rescue Time.now
      entry = { day: t.day, month: t.month, year: t.year, date: t, from: from }    
      body.gsub!(/On(?:(?!On).)*?wrote:/m, '')
      body.gsub!(/\n>/, '')
      entry[:content] = body || "" 
            
      entries << entry
      message.delete

    end 
      
    pop.finish
  
    return entries
  end
  
  #
  #  and this is to tap into ActionMailer receiving capabilities
  #
  def receive( email )

    if email.multipart?
      if email.text_part
        body = email.text_part.body.decoded
      end
    else
      body = email.decoded
    end


    return email.from.first, email.subject, body

  end   
      
end
