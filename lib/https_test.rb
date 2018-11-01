require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'net/http'
require 'json'

def try_https( url )
  uri = URI( 'https://'+url+'/index' )
  puts "trying URI https://"+url+"/index"
  http = Net::HTTP::new( uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  return response

end

def try_http( url )
  uri = URI( 'http://'+url+'/index' )
  puts "trying URI http://"+url+"/index"
  http = Net::HTTP::new( uri.host, uri.port)
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  return response

end

#p try_https('www.menhardt.com')
#p try_http('www.menhardt.com')

uri = URI( 'https://www.google.com' )
puts "trying URI https://www.google.com"
http = Net::HTTP::new( uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
