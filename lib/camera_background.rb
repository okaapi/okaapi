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

mail_config = (YAML::load( File.open(Rails.root + 'config/camera_mail.yml') ))

smtp_settings = mail_config["server"].merge(mail_config["credentials"]).merge(mail_config["pop"]).symbolize_keys
      
#p smtp_settings
          
Mail.defaults do
  retriever_method :pop3, :address    => smtp_settings[:pop_server],
                          :port       => smtp_settings[:port],
                          :user_name  => smtp_settings[:user_name],
                          :password   => smtp_settings[:password],
                          :enable_ssl => smtp_settings[:enable_ssl]
end

marray = ['dummy']

panasonic_index = 0
dlink_index = 0

puts ""
puts "GETTING CAMERA MAILS at #{Time.now}"
puts ""

if true  #( Time.now.hour == 21 )

  directory = File.join( Rails.root , 'public', 'camera')
  Dir.mkdir directory if ! Dir.exists? directory
  directory = File.join( Rails.root , 'public', 'camera', engarble( Date.today.to_s ) )
  if ! Dir.exists? directory
  Dir.mkdir directory
    #File.chmod(0700, directory)
  end
  puts "USING DIRECTORY #{directory}"
  puts "\n"
  until marray.count == 0 
  
    marray = Mail.all
    puts "FOUND #{marray.count} MESSAGES"
    puts "\n"
    marray.each do |message|
      message_received=message.received[0].field.element.date_time
      puts "MESSAGE SUBJECT #{message.subject}\n"
      puts "MESSAGE SENT AT #{message.date}\n"
      puts "MESSAGE RECEIVED AT #{message_received}\n"
      p message.text_part.body.decoded
      
      #p message.from[0]
      #p message.date
      #p message.subject  
      #p message.cc  
      #p message.return_path
      #p message.to  
      #p message.message_id

      # this seems to make no difference?
      message.mark_for_delete = true  
 
      if !message_received
        common_filename = "#{message.date.strftime("%-d%b_%Hh%Mm%Ss")}.jpg"
      else
        common_filename = "#{message_received.strftime("%-d%b_%Hh%Mm%Ss")}.jpg"
      end
      message.attachments.each do | attachment |  
        if (attachment.content_type.start_with?('image/'))
          if attachment.filename == 'image.jpg'
            #panasonic
            filename = 'panasonic_' + common_filename
            filename = filename.gsub('.jpg', pansonic_index.to_s+'.jpg')
            panasonic_index += 1
          else
            #dlink
            filename = 'dlink_' + common_filename
            filename = filename.gsub('.jpg', dlink_index.to_s+'.jpg')
            dlink_index += 1
          end
          puts "SAVING #{filename}"
          puts ""
          begin
            path = File.join( directory, filename )
            File.open(path, "w+b", 0777) {|f| f.write attachment.body.decoded}
          rescue => e
            puts "Unable to save data for #{filename} because #{e.message}"
          end
        end
      end
      
    end
    
  end

    
  puts "DONE PROCESSING MESSAGES"     

end


