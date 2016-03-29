
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)

str = "Bla bla " +
" From: ABS From: Automatic Diary [mailto:automaticdiary@gmail.com] 
               Sent: Friday, March 25, 2016 6:00 PM
               To: wido@menhardt.com
               Subject: What did you do on Friday 25 March ? " +  "Bli ? bli "

#str = str.gsub!( /(From: Automatic Diary .*?\?)?/ ,'' )     
     
str = str.gsub!( /(From: Automatic Diary.*?\?)?/m ,'' )

p str


