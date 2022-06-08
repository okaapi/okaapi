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
    
end
