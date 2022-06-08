
require "rubygems"
require 'net/smtp'


require "../../config/environment" unless defined?(::Rails.root)

(1..3).each {puts "."}
puts "raise_delivery_errors is #{Rails.configuration.action_mailer.raise_delivery_errors}"
puts "delivery method is #{Rails.configuration.action_mailer.delivery_method}"
puts "delivery performance is #{Rails.configuration.action_mailer.perform_deliveries}"

(1..3).each {puts "."}
puts "AuthenticationNotifier smtp settings"
AuthenticationNotifier.smtp_settings.each do |f,v|
  puts "#{f} => #{v}"
end

(1..3).each {puts "."}
puts "DiaryReminder smtp settings"
DiaryReminder.smtp_settings.each do |f,v|
  puts "#{f} => #{v}"
end


(1..3).each {puts "."}
puts "Sending diary reminder"
mail = DiaryReminder.send_diary_reminder( "wido@menhardt.com", " towards my goal" ).deliver

(1..3).each {puts "."}
puts "Sending okaapi reminder"
mail = OkaapiMailer.send_okaapi_reminder( "wido@menhardt.com", "some subject", "tides", [["person"=>"1"]], ["priorities"] ).deliver


(1..3).each {puts "."}
puts "Sending authentication mail"
mail = AuthenticationNotifier.test( "wido@menhardt.com" ).deliver
