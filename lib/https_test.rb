require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'net/http'
require 'json'

def try_https( url )
  uri = URI( 'https://'+url+'/index' )
  http = Net::HTTP::new( uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  p response

end

try_https('www.menhardt.com')
