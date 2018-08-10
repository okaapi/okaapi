require 'net/http'
require "../../config/environment" unless defined?(::Rails.root)

puts Tides.get_santa_cruz_tides

json_launch = { version: "1.0",
                request: {
                  type: "LaunchRequest"
                }
              }
              
  #uri = URI('http://localhost:3000/tides')
  uri = URI('https://www.okaapi.com/tides')
  puts uri.host+uri.path
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
  req.body = json_launch.to_json
  res = http.request(req)

puts "RESPONSE #{res.body}"                


    
