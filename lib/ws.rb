require 'faye/websocket'
#require 'em/pure_ruby'
require 'eventmachine'

EM.run {
  ws = Faye::WebSocket::Client.new('ws://www.okaapi.com/')

  ws.on :open do |event|
    p [:open]
    ws.send('Hello, world!')
  end

  ws.on :message do |event|
    p [:message, event.data]
  end

  ws.on :close do |event|
    p event
    p [:close, event.code, event.reason]
    ws = nil
  end
}