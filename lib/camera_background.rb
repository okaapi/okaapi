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
def purge_directories( maxdatediff = 31 )
  directory = File.join( Rails.root , 'public', 'camera')
  if Dir.exists? directory
    datelist = Dir.entries(directory).reject{|entry| entry =~ /^\.{1,2}$/}.sort
    datelist.each do |date|
      datediff = (Date.today - Date.parse( degarble(date) )).to_i
      datedirectory = File.join( directory, date )  
      if datediff > maxdatediff
        FileUtils.rm_rf(datedirectory)
      end
    end
  end
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

  marray = Mail.all
  puts "FOUND #{marray.count} MESSAGES"
  puts "\n"

  directory = File.join( Rails.root , 'public', 'camera')
  Dir.mkdir directory if ! Dir.exists? directory
  directory = File.join( Rails.root , 'public', 'camera', engarble( Date.today.to_s ) )
  if ! Dir.exists? directory
    Dir.mkdir directory
    #File.chmod(0700, directory)
  end
  
#  until marray.count == 0 
  
    puts "USING DIRECTORY #{directory}"
    puts "\n"
        
    marray.each_with_index do |message,index|

      puts "MESSAGE #{index} SUBJECT #{message.subject}\n"
      puts "TIME NOW #{Time.now()}\n"
      if message.received.class == Array
        if message.received[0] == Mail::Field
          message_received = message.received[0].date_time
        end
      elsif message.received.class == Mail::Field
        message_received = message.received.date_time
      else
        message_received = Time.now
      end
      puts "MESSAGE RECEIVED #{message_received}\n"     
      puts "MESSAGE SENT AT #{message.date}\n"
      begin
        message_timestamp = Time.parse(message.subject)
      rescue => e
        puts "USING message.date because of exception"
        message_timestamp = message.date
      end
      if message_timestamp.hour == 0 and message_timestamp.min == 0
        puts "USING message.date because hour and minute are zero"
        message_timestamp = message.date
      end 

      puts "MESSAGE TIMESTAMP #{message_timestamp}\n"
      
      puts "MESSAGE BODY: #{message.text_part.body.decoded}\n"
      puts "---"
      
      message.mark_for_delete = true
 
      dlink_index = 0
      message.attachments.each do | attachment |  
        if (attachment.content_type.start_with?('image/'))
          cam_type = ''
          if attachment.filename == 'image.jpg'
            cam_type = 'panasonic'            
            common_filename = "#{message_timestamp.strftime("%-d%b_%Hh%Mm%Ss")}.jpg"
            filename = 'panasonic_' + common_filename
            panasonic_index += 1
          else
            cam_type = 'dlink'
            common_filename = "#{message_timestamp.strftime("%-d%b_%Hh%Mm%Ss")}.jpg"
            filename = 'dlink_' + common_filename
            filename = filename.gsub('.jpg', dlink_index.to_s+'.jpg')
            dlink_index += 1
          end
          if cam_type == 'panasonic' or
            # dlink takes a couple of images before and after 
            ( cam_type == 'dlink' and dlink_index.modulo(6) == 4 )
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
    
#end
  puts "DONE PROCESSING MESSAGES"     


  begin
    Dir.chdir(directory){
      imagefiles = Dir.entries(directory).sort                                   
      if imagefiles.find{|each| ( each.include? 'panasonic' )}
        %x[#{"ffmpeg -y -hide_banner -loglevel panic -r 60 -pattern_type glob -i 'panasonic*.jpg' -filter:v 'setpts=30.0*PTS' -vcodec mpeg4 panasonic.avi"}]
        %x[#{"ffmpeg -y -hide_banner -loglevel panic -r 60 -pattern_type glob -i 'panasonic*.jpg' -filter:v 'setpts=30.0*PTS' -f mp4 -vcodec libx264 panasonic.mp4"}]
      end
    }
  rescue e
    puts "error writing panasonic video file"
    p e
  end

  begin
    Dir.chdir(directory){
      imagefiles = Dir.entries(directory).sort                                   
      if imagefiles.find{|each| ( each.include? 'dlink' )}
        %x[#{"ffmpeg -y -hide_banner -loglevel panic -r 60 -pattern_type glob -i 'dlink*.jpg' -filter:v 'setpts=30.0*PTS' -vcodec mpeg4 dlink.avi"}]
        %x[#{"ffmpeg -y -hide_banner -loglevel panic -r 60 -pattern_type glob -i 'dlink*.jpg' -filter:v 'setpts=30.0*PTS' -f mp4 -vcodec libx264 dlink.mp4"}]
      end
    }
  rescue e
    puts "error writing dlink video file"
    p e
  end
  
  puts "DONE CREATING VIDEOFILES"     

  purge_directories( 5 )

  puts "DONE PURGING DIRECTORIES"     


end

