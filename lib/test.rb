
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)


def encrypt( str )
  o = ""; 
  str.each_char { |c| o << (c.ord+30).chr }; 
  o
end   
def decrypt( str )
  o = ""; 
  str.each_char { |c| o << (c.ord-30).chr }; 
  o
end 
  
d = Date.today.to_s
puts '---------------------'
puts d
puts '---------------------'
dn = encrypt(d) 
p dn
puts '---------------------'
p decrypt( dn) 
puts '---------------------'
