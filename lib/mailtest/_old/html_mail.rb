
require File.dirname(__FILE__) + "/../../config/environment" unless defined?(RAILS_ROOT)
require 'mail'

Mail.defaults do
    delivery_method :smtp, address: "smtp.1and1.com", port: 587, domain: "okaapi.com", authentication: "plain", enable_starttls_auto: true, user_name: "email@okaapi.com", password: "Adjk34x@7d7s"
end


mail = Mail.deliver do
  to      'wido.menhardt@evidentscientific.com'
  from    'wido@menhardt.com'
  subject 'First multipart email sent with Mail'

  text_part do
    body 'This is plain text'
  end

  html_part do
    content_type 'text/html; charset=UTF-8'
    body '<h1>This is HTML</h1><a href="https://www.menhardt.com/storage/www.menhardt.com/wido_left/ski2007.jpg"><img src="https://www.menhardt.com/storage/www.menhardt.com/wido_left/ski2007.jpg?17"></a>'
  end
end


p mail
