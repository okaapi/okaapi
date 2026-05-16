require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)


new_okaapis, new_diary_entries = GeneralReceiver.get_entries

p new_okaapis.count
p new_diary_entries.count
