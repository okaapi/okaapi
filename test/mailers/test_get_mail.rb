require "rubygems"
require 'net/smtp'

require File.dirname(__FILE__) + "/../../config/environment" unless defined?(RAILS_ROOT)

(1..3).each {puts "."}
puts "DiaryReminder smtp settings"
DiaryReminder.smtp_settings.each do |f,v|
  puts "#{f} => #{v}"
end

(1..3).each {puts "."}
puts "OkaapiMailer smtp settings"
OkaapiMailer.smtp_settings.each do |f,v|
  puts "#{f} => #{v}"
end

(1..3).each {puts "."}
puts "General Receiver Diary Entries----------------------------------------------------------"
okaapis, entries = GeneralReceiver.get_entries
entries.each do |e|
  p e
  (1..2).each {puts "."}
end

(1..3).each {puts "."}
puts "General Receiver Okaapis----------------------------------------------------------"
entries, diary_entries = GeneralReceiver.get_entries
entries.each do |e|
  p e
  (1..2).each {puts "."}
end
