class DiaryController < ApplicationController
  COLORS = ['purple', 'blue', 'green', 'magenta', 'orange']
  def calendar
    
	if !@current_user
	  redirect_to who_are_u_path
	end
	
    @month = params[:month].to_i if params[:month]
    @year = params[:year].to_i if params[:year]
    # set the date to the last available diary entry for this user
    if !@month or !@year 
      if @current_user
        @day, @month, @year = DiaryEntry.last_entry( @current_user.id)
      else
        t = Time.new; @day = t.day; @month = t.month; @year = t.year
      end
    else 
      # we let the UI increment months beyond 1 or 12 so need to
      # correct those
      if @month == 13
        @month = 1
        @year += 1
      elsif @month == 0
        @month = 12
        @year -= 1
      end
    end
      
    # a super-smart calendar generator!
    # this is the week day of the first day of the month
    first_day = Time.parse("1-#{@month}-#{@year}").wday
    first_day = 7 if first_day == 0 # don't want sunday to be zero
    # this is the last day of the month
    last_day = Time.days_in_month( @month, @year )
    # this is the monday of the first week, usually a negative number:
    #   first_day = monday(1) -> first week monday = 1
    #   first_day = tuesday(2) -> first week monday = 0
    #   first_day = wednesday(3) -> first week monday = -1
    #   first_day = saturday(6) -> first week monday = -4
    #   first_day = sunday(0) -> first week monday = -5
    day_in_month = 2 - first_day
	tags = []
    @calendar = {}
    (1..6).each do |week|
      thisweek = {}
      (1..7).each do |day|
        if day_in_month < 1 or day_in_month > last_day
          thisweek[day] = nil
        else 
          if @current_user 
            entry = DiaryEntry.entry_for_day( @current_user.id, day_in_month, @month, @year )
            entry_tags = DiaryEntry.tags(entry)
	    tags += entry_tags if entry_tags
            thisweek[day] = { day: day_in_month,  content: entry }
          else
            thisweek[day] = { day: day_in_month }
          end
        end		
        day_in_month += 1
      end
      @calendar[week]= thisweek
    end
    @tag_list = []
    tags.each { |t| @tag_list += [t[0]] if !@tag_list.include?(t[0]) }
    @colors = COLORS
  end
  
  def show_entry
    if @current_user
      @day = params[:day]
      @weekday = params[:weekday]
      @month = params[:month]
      @year = params[:year]    
      @week = params[:week]
      @entry = DiaryEntry.entry_for_day( @current_user.id, 
                                  @day, @month, @year )
      @entry = @entry.force_encoding("UTF-8") if @entry
      @divid = '#show_diary_entry' + @week.to_s
	  tags = DiaryEntry.tags(@entry)
	  @tag_list = []
	  tags.each { |t| @tag_list += [t[0]] } if tags
    else
      redirect_to who_are_u_path
    end
  end
  
  def update_entry
  
    if @current_user
      @day = params[:day]
      @month = params[:month]
      @year = params[:year]  
      @weekday = params[:weekday]
      @week = params[:week]    
      @divid = '#show_diary_entry' + @week.to_s    
      @entry = params[:entry]    
      DiaryEntry.replace_entry_for_day( @current_user.id, 
                                  @day, @month, @year, @entry )                       
      redirect_to calendar_path( month: @month, year: @year )
    else
      redirect_to who_are_u_path
    end    
  end  
  
  def show_tag
    if @current_user
	  @tag = params[:tag]
      @month = params[:month]
      @year = params[:year]    
	  @events = []
      (1..31).each do |day_in_month|
		entry = DiaryEntry.entry_for_day( @current_user.id, day_in_month, @month, @year )
		entry_tags = DiaryEntry.tags(entry)
		entry_tags.each do |t|
		  if t[0] == @tag
			@events << [ day_in_month, t[1] ]
	      end
		end	if entry_tags
      end		
    else
      redirect_to who_are_u_path
    end
  end  
  
  def turn_off_diary_emails
    
    if @current_user
      @current_user.diary_service = "off"
      @current_user.save!(validate: false)
	  redirect_to calendar_path, notice: "daily reminders turned off"
    else
      redirect_to who_are_u_path
    end       
    
  end

  def send_diary_email
    
    if @current_user
      if @current_user.diary_service == "off"
        @current_user.diary_service = "on"
        @current_user.save!(validate: false)
      end
      DiaryReminder.send_diary_reminder( @current_user.email, @current_user.goal_in_subject,
                                         Time.now ).deliver_now
      redirect_to calendar_path, notice: "daily reminders sent to  #{@current_user.email}"
    else
      redirect_to who_are_u_path
    end   
    
  end
  
  # wget http://0.0.0.0:3000/diary/send_all_diary_emails -O /dev/null
  def send_all_diary_emails
    
    Postoffice.send_all_diary_emails( params[:token] )
    redirect_to calendar_path, notice: "sent all diary emails"
        
  end

  def receive_diary_emails

    n = Postoffice.receive_diary_emails    

    redirect_to calendar_path, notice: "received #{n} diary emails"

  end
  
end
