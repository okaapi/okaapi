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

puts 
puts "GETTING CAMERA MAILS at #{Time.now}"

if true  #( Time.now.hour == 21 )

	directory = File.join( Rails.root , 'public', 'camera')
	Dir.mkdir directory if ! Dir.exists? directory
	directory = File.join( Rails.root , 'public', 'camera', engarble( Date.today.to_s ) )
        if ! Dir.exists? directory
	  Dir.mkdir directory
          #File.chmod(0700, directory)
        end
        puts "into directory #{directory}"		        
	"A======================================================"
	until marray.count == 0 
	
	    "B======================================================="
		marray = Mail.all
		"1======================================================"
		marray.each do |message|
		  #p message.from[0]
		  #puts "++++++++++++++++++++++++++++++++++++++++"
		  #p message.date
		  puts "++++++++++++++++++++++++++++++++++++++++"
		  p message.subject  
		  #puts "++++++++++++++++++++++++++++++++++++++++"#filename = 'dlink' + dlink_index.to_s + '.jpg'
		  p message.text_part.body.decoded
		  #puts "++++++++++++++++++++++++++++++++++++++++"
		  #p message.cc  
		  #puts "++++++++++++++++++++++++++++++++++++++++"
		  #p message.return_path
		  #puts "++++++++++++++++++++++++++++++++++++++++"
		  #p message.to  
		  #puts "++++++++++++++++++++++++++++++++++++++++"
		  #p message.message_id
		  message.mark_for_delete = true  
		  
		  p message.date
		  message.attachments.each do | attachment |  
		    if (attachment.content_type.start_with?('image/'))
		      if attachment.filename == 'image.jpg'
	            #panasonic
		        #filename = 'panasonic' + panasonic_index.to_s + '.jpg'	
		        slist = message.subject.split('Image:')
		        t = slist[1].split('s')
		        filename = "panasonic#{t[1][0..1]}h#{t[1][2..3]}m#{t[1][4..5]}s.jpg"
	            panasonic_index += 1
	          else
	            #dlink
		        #filename = 'dlink' + dlink_index.to_s + '.jpg'
		        filename = "dlink#{message.date.strftime("%Hh%Mm%Ss")}.jpg"
	            dlink_index += 1
		      end
		      puts "saving #{filename}"
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
    "2======================================================"
    
    puts "#{marray.count} messages"     

end


