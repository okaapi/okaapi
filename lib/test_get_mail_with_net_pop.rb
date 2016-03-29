
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
  
  
require 'net/pop'
require 'mail'
require 'pp'

pop = Net::POP3.new "pop.gmail.com"
pop.enable_ssl
pop.start 'camera@menhardt.com', 'fV2z6OE2gkJ'
pop.each_mail do |message|
  from, subject, body = receive( message.pop )
  p subject
end 
pop.finish



require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)

Mail.defaults do
  retriever_method :pop3, :address    => "pop.gmail.com",
                          :port       => 995,
                          :user_name  => 'camera@menhardt.com',
                          :password   => 'fV2z6OE2gkJ',
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
  message.mark_for_delete = true  
end
puts "#{marray.count} messages"