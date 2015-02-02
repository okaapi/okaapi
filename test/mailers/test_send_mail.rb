require "rubygems"
require 'net/smtp'


require File.dirname(__FILE__) + '.\..\config\environment'
#require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)

(1..3).each {puts "."}
puts "raise_delivery_errors is #{Rails.configuration.action_mailer.raise_delivery_errors}"
puts "delivery method is #{Rails.configuration.action_mailer.delivery_method}"
puts "delivery performance is #{Rails.configuration.action_mailer.perform_deliveries}"

(1..3).each {puts "."}
puts "AuthenticationNotifier smtp settings"
Auth::AuthenticationNotifier.smtp_settings.each do |f,v|
  puts "#{f} => #{v}"
end

(1..3).each {puts "."}
puts "DiaryReminder smtp settings"
DiaryReminder.smtp_settings.each do |f,v|
  puts "#{f} => #{v}"
end


(1..3).each {puts "."}
puts "Sending diary reminder"
mail = DiaryReminder.send_diary_reminder( "wido@menhardt.com" ).deliver

(1..3).each {puts "."}
puts "Sending okaapi reminder"
mail = OkaapiMailer.send_okaapi_reminder( "wido@menhardt.com", "some subject" ).deliver


(1..3).each {puts "."}
puts "Sending authentication mail"
mail = Auth::AuthenticationNotifier.test( "wido@menhardt.com" ).deliver