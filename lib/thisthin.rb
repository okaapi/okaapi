require 'eventmachine'
require 'rack'
require 'thin'
require './ws-server'

Faye::WebSocket.load_adapter('thin')

thin = Rack::Handler.get('thin')

thin.run(App, :Port => 9292) do |server|
  # You can set options on the server here, for example to set up SSL:
  server.ssl_options = {
    :private_key_file => 'path/to/ssl.key',
    :cert_chain_file  => 'path/to/ssl.crt'
  }
  server.ssl = true
end
