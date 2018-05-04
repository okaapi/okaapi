require "../../config/environment" unless defined?(::Rails.root)

require 'net/http'
require 'json'

json_launch = { version: "1.0",
                request: {
                  type: "LaunchRequest"
                }
              }
json_overview = { version: "1.0",
              request: {
                type: "IntentRequest",
                intent: {
                  name: "Overview",
                  confirmationStatus: "NONE"
                }
              }
            }
json_turnaround = { version: "1.0",
              request: {
                type: "IntentRequest",
                intent: {
                  name: "Turnaround",
                  confirmationStatus: "NONE"
                }
              }
            }            
json_samplevolume = { version: "1.0",
              request: {
                type: "IntentRequest",
                intent: {
                  name: "Samplevolume",
                  confirmationStatus: "NONE"
                }
              }
            }
json_stop = { version: "1.0",
              request: {
                type: "IntentRequest",
                intent: {
                  name: "AMAZON.StopIntent",
                  confirmationStatus: "NONE"
                }
              }
            }
json_help = { version: "1.0",
              request: {
                type: "IntentRequest",
                intent: {
                  name: "AMAZON.HelpIntent",
                  confirmationStatus: "NONE"
                }
              }
            }
                        
while true

  puts "L = launch"
  puts "o = overview"
  puts "t = turnaround"
  puts "s = samplevolume"
  puts "H = help"  
  puts "S = stop"
  puts ">>>"
  x = gets

  case x[0]
  when 'L'
    json = json_launch
  when 'o'
    json = json_overview
  when 't'
    json = json_turnaround
  when 's'
    json = json_samplevolume
  when 'S'
    json = json_stop
  when 'H'
    json = json_help    
  else
    json = {nothing: 'no valid input'}
  end
  puts "REQUEST #{json}"
  
  uri = URI('http://localhost:3000/alexa')
  #uri = URI('https://www.okaapi.com/alexa')
  puts uri.host+uri.path
  http = Net::HTTP.new(uri.host, uri.port)
  #http.use_ssl = true
  req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
  req.body = json.to_json
  res = http.request(req)

  puts "RESPONSE #{res.body}"  
  puts
  
  begin
    res = eval(res.body)
    if res[:response][:outputSpeech]
      puts res[:response][:outputSpeech][:text]
    elsif res[:response][:directives]
      puts res[:response][:directives][0][:type]
    end
  rescue SyntaxError
    puts "exit with errors"
  end
  puts 


end
