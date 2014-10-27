class DiaryController < ApplicationController
  
  def calendar
    
    @user = get_current_user( session[:user_session_id] )
    @calendar = {}
    @month = params[:month].to_i if params[:month]
    @year = params[:year].to_i if params[:year]
          
    if @user
      
      if !@month or !@year
        @day, @month, @year = DiaryEntry.last_entry( @user.id)
      else
        # we let the UI increment months beyond 1 or 12...
        if @month == 13
          @month = 1
          @year += 1
        elsif @month == 0
          @month = 12
          @year -= 1
        end
      end
      
      first_day = Time.parse("1-#{@month}-#{@year}").wday
      last_day = Time.days_in_month( @month, @year )
      day_in_month = 2 - first_day
      (1..5).each do |week|
        thisweek = {}
        (1..7).each do |day|
          if day_in_month < 0 or day_in_month > last_day
            thisweek[day] = 0
          else
            thisweek[day] = day_in_month
          end
          day_in_month += 1
        end
        @calendar[week]= thisweek
      end   
      
    end
    
  end
  
  def turn_off_diary_emails
    @user = get_current_user( session[:user_session_id] )
        
    if @user
      @user.diary_service = "off"
      @user.save!(validate: false)
      redirect_to root_path, notice: "daily reminders turned off"
    else
      redirect_to root_path
    end
  end

  def send_diary_email
    @user = get_current_user( session[:user_session_id] )
          
    if @user
      if @user.diary_service == "off"
        @user.diary_service = "on"
        @user.save!(validate: false)
      end
      DiaryReminder.send_diary_reminder( @user.email, Time.now ).deliver
      redirect_to root_path, notice: "daily reminders sent to  #{@user.email}"
    else
      redirect_to root_path, notice: "no mail sent"
    end
  end
  
  # wget http://0.0.0.0:3000/diary/send_all_diary_emails -O /dev/null
  def send_all_diary_emails
    @users = Auth::User.where( diary_service: "on")
    @users.each do |user|
      DiaryReminder.send_diary_reminder( user.email, Time.now ).deliver
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
    redirect_to root_path
  end
  
end
