require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'mail'

#
# ffmpeg -i panasonic%d.jpg -vcodec mpeg4 panasonic.avi
#

def engarble( str )
  o = ""; 
  str.each_char { |c| o << (c.ord+30).chr }; 
  o
end   
def degarble( str )
  o = ""; 
  str.each_char { |c| o << (c.ord-30).chr }; 
  o
end 


def purge_directories( maxdatediff = 31 )
  directory = File.join( Rails.root , 'public', 'camera')
  if Dir.exists? directory
    datelist = Dir.entries(directory).reject{|entry| entry =~ /^\.{1,2}$/}.sort
    datelist.each do |date|
      datediff = (Date.today - Date.parse( degarble(date) )).to_i
      puts datediff
      puts date
      puts degarble(date)
      datedirectory = File.join( directory, date )  
      puts datedirectory
      if datediff > maxdatediff
        FileUtils.rm_rf(datedirectory)
      end
    end
  end
end
