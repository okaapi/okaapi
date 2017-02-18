require File.dirname(__FILE__) + "/../../config/environment" unless defined?(RAILS_ROOT)


new_entries = DiaryReceiver.get_diary_entries 

p new_entries.count
