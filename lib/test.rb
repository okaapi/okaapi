
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)

a = ActionController::Parameters.new( a: "a", b: "b"  )

p a
p a.to_s

a.each do |k,v|
  puts "#{k} => #{v}"
end