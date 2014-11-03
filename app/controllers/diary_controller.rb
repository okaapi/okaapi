class DiaryController < ApplicationController
   
  def calendar
    

    @month = params[:month].to_i if params[:month]
    @year = params[:year].to_i if params[:year]
    # set the date to the last available diary entry for this user
    if !@month or !@year 
      if @user
        @day, @month, @year = DiaryEntry.last_entry( @user.id)
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
    first_day = Time.parse("1-#{@month}-#{@year}").wday
    last_day = Time.days_in_month( @month, @year )
    day_in_month = 2 - first_day
    @calendar = {}
    (1..5).each do |week|
      thisweek = {}
      (1..7).each do |day|
        if day_in_month < 1 or day_in_month > last_day
          thisweek[day] = nil
        else 
          if @user 
            thisweek[day] = { day: day_in_month, 
                              content: DiaryEntry.entry_for_day( @user.id, day_in_month, @month, @year ) }
          elsif rand > 0.5
            thisweek[day] = { day: day_in_month, 
                   content: "your diary entry here!" }
          else
            thisweek[day] = { day: day_in_month }
          end
        end
        day_in_month += 1
      end
      @calendar[week]= thisweek
    end         
        
  end
  
  def turn_off_diary_emails
    
    if @user
      @user.diary_service = "off"
      @user.save!(validate: false)
      redirect_to :back, notice: "daily reminders turned off"
    end
    
  end

  def send_diary_email
    
    if @user
      if @user.diary_service == "off"
        @user.diary_service = "on"
        @user.save!(validate: false)
      end
      DiaryReminder.send_diary_reminder( @user.email, Time.now ).deliver
      redirect_to :back, notice: "daily reminders sent to  #{@user.email}"
    end
    
  end
  
  # wget http://0.0.0.0:3000/diary/send_all_diary_emails -O /dev/null
  def send_all_diary_emails
    
    if params[:token] 
      @users = Auth::User.where( diary_service: "on")
      @users.each do |user|
        DiaryReminder.send_diary_reminder( user.email, Time.now, params[:token] ).deliver
      end
    end    
    redirect_to root_path
        
  end

  def receive_diary_emails
    
    @new_entries = DiaryReminder.get_diary_entries 
    @new_entries.each do |entry|
      if user = Auth::User.where( email: entry[:from] ).first
        de = DiaryEntry.new( entry )
        de.user_id = user.id
        de.save!
      end
    end
    redirect_to :back
    
  end
  
end
