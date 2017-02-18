require File.dirname(__FILE__) + "/../../config/environment" unless defined?(RAILS_ROOT)

mail_config = (YAML::load( File.open(Rails.root + 'config/diary_mail.yml') ))
smtp_settings = mail_config["server"].merge(mail_config["credentials"]).merge(mail_config["pop"]).symbolize_keys

p smtp_settings
      
require 'mail'

Mail.defaults do
  retriever_method :pop3, :address    => smtp_settings[:pop_server],
                          :port       => 995,
                          :user_name  => smtp_settings[:user_name],
                          :password   => smtp_settings[:password],
                          :enable_ssl => true
end
  
marray = Mail.all
marray.each do |message|
  #p message.from[0]
  #puts "++++++++++++++++++++++++++++++++++++++++"
  #p message.date
  puts "++++++++++++++++++++++++++++++++++++++++"
  p message.subject  
  #puts "++++++++++++++++++++++++++++++++++++++++"
  p message.text_part.body.decoded
  #puts "++++++++++++++++++++++++++++++++++++++++"
  #p message.cc  
  #puts "++++++++++++++++++++++++++++++++++++++++"
  #p message.return_path
  #puts "++++++++++++++++++++++++++++++++++++++++"
  #p message.to  
  #puts "++++++++++++++++++++++++++++++++++++++++"
  #p message.message_id
  #message.mark_for_delete = true  
end
puts "#{marray.count} messages"