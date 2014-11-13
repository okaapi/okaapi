require "../config/environment" unless defined?(::Rails.root)

#dbconfig = YAML::load(File.open('../config/database.yml'))
#ActiveRecord::Base.establish_connection(dbconfig["development"])

puts "background.rb at #{Time.now.utc} or #{Time.now}"
puts
puts "PROCESSING INCOMING MAILS"
puts

n = Postoffice.receive_diary_emails
puts "received #{n} diary emails"
n = Postoffice.receive_okaapi_emails
puts "received #{n} okaapi emails"

puts
puts "SENDING MAILS"
puts 

if ( Time.now.min < 15 ) && ( Time.now.hour == 18 )
  n = Postoffice.send_all_diary_emails( 1959 ) 
  puts "sent #{n} diary reminder emails"
end

puts 
puts "DONE WITH OKAAPI"
puts