require "../config/environment" unless defined?(::Rails.root)

#dbconfig = YAML::load(File.open('../config/database.yml'))
#ActiveRecord::Base.establish_connection(dbconfig["development"])

ZiteActiveRecord.site( "www.okaapi.com" )

puts "background.rb at #{Time.now.utc} or #{Time.now}"
puts
puts "PROCESSING INCOMING MAILS"
puts

n_o, n_d = Postoffice.receive_okaapi_and_diary_emails
puts "received #{n_d} diary emails"
puts "received #{n_o} okaapi emails"

puts
puts "SENDING MAILS"
puts 

if ( Time.now.hour == 18 )
  n = Postoffice.send_all_diary_emails( 1959 ) 
  puts "sent #{n} diary reminder emails"
  n = Postoffice.send_okaapi_emails 
  puts "sent #{n} okaapi emails"
end

puts 
puts "DONE WITH OKAAPI"
puts
