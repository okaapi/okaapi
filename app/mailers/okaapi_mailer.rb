require 'net/pop'
class OkaapiMailer < ActionMailer::Base

  
  # this gets executed once when the class is initialized
  mail_config = (YAML::load( File.open(Rails.root + 'config/okaapi_mail.yml') ))
  self.smtp_settings = mail_config["server"].merge(mail_config["credentials"])
      .merge(mail_config["pop"]).symbolize_keys
  
  #
  #
  #
  def send_okaapi_reminder( user_email, subj, tides, people, prio_okaapis )
    @tides = tides
    @people = people
    @okaapis = prio_okaapis
    mail from: smtp_settings[:sender_email], to: user_email, subject: subj
  end
    
  #
  #
  #
  def test( user_email )
    p smtp_settings
    mail from: smtp_settings[:sender_email], to: user_email
  end
    
  # 
  #  yeah, so we're using smtp_settings also for pop
  #
  def self.get_okaapis
  
    pop = Net::POP3.new smtp_settings[:pop_server]
    pop.enable_ssl
    pop.start smtp_settings[:user_name], smtp_settings[:password]
      
    entries = []
    pop.each_mail do |message|

      message_obj = Mail.new(message.pop)
      from = message_obj.from
      subj = message_obj.subject
      t = message_obj.date
      if message_obj.multipart?
        if message_obj.text_part
          body = message_obj.text_part.body.decoded
        end
      else
        body = message_obj.decoded
      end
     
      r = subj.split("#")
      subject = r[0]
      t_r = Time.parse(r[1..-1].join("#")) rescue Time.now
      # if t_r is very close to "now", assume there is no reminder specified... remind tomorrow
      if (Time.now - t_r).to_i.abs < 3
        t_r = (t.utc + 1 ).to_s
      else
        t_r = t_r.utc.to_s
      end        
      
      entry = { time: t, from: from, content: ( body || "" ),
                subject: subject, reminder: t_r }    
            
      entries << entry
      message.delete

    end 
      
    pop.finish
  
    return entries
  end


end
