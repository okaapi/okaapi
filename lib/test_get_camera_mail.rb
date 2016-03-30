require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)

Mail.defaults do
  retriever_method :pop3, :address    => "pop.gmail.com",
                          :port       => 995,
                          :user_name  => 'camera@menhardt.com',
                          :password   => 'fV2z6OE2gkJ',
                          :enable_ssl => true
end

marray = ['dummy']

until marray.count == 0 

	marray = Mail.all
	marray.each do |message|
	  #p message.from[0]
	  #puts "++++++++++++++++++++++++++++++++++++++++"
	  #p message.date
	  puts "++++++++++++++++++++++++++++++++++++++++"
	  p message.subject  
	  #puts "++++++++++++++++++++++++++++++++++++++++"
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
	  
	  message.attachments.each do | attachment |  
	    if (attachment.content_type.start_with?('image/'))
	      filename = attachment.filename
	      if filename == 'image.jpg'
	        filename = 'image ' + message.date.to_s + ' .jpg'
	      end
	      puts "saving #{filename}"
	      begin
	        File.open('images/' + filename, "w+b", 0644) {|f| f.write attachment.body.decoded}
	      rescue => e
	        puts "Unable to save data for #{filename} because #{e.message}"
	      end
	    end
	  end
	  
	end
  
    puts "#{marray.count} messages"
    
end    

