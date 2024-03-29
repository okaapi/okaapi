
class AuthenticateController < ApplicationController

  # max retries for password
  MAX_RETRIES = 3 
  
  def who_are_u  
	
    # figure out from which page user is logging into
    a = request.headers['HTTP_REFERER']	
    login_from = a[a.rindex('/')+1..a.length] if a	
    if defined?( Page )
      session[:login_from] = login_from if Page.get_latest( login_from )
    else 
      session[:login_from] = login_from
    end
	 
    # check whether user is already logged in 
    if @current_user
      # just in case somebody else has cached pages
      uncache_all
      redirect_to_action_html( { alert: "#{@current_user.username} already logged in" }, 
                                       login_from)  
      authentication_logger("who_are_u from page #{session[:login_from]} but #{@current_user.username} already logged in")	                                              
    else
      # ask the user for their username
      authentication_logger("who_are_u from page #{session[:login_from]}")	
    end
    
  end

  def prove_it
    	
    uncache_all
    
    login_from = session[:login_from]
    
    authentication_logger('---')
    authentication_logger('start of prove_it')        
    authentication_logger("  logged in from page #{login_from}")

    @claim = params[:claim]
    @password = params[:kennwort]
    # this is for testing email failure exception code    
    @eft = params[:ab47hk]
        
    
    # if we're already logged in
    if @current_user
	  if login_from != '_prove_it' 
        redirect_to_action_html( { alert: "#{@current_user.username} already logged in" }, 
                                       login_from)  
      else
	    redirect_to_action_html( { alert: "#{@current_user.username} already logged in" } )
	  end
      authentication_logger("prove_it but #{@current_user.username} already logged in")   
      
    # this is the first time we come here
    elsif !@password
      session[:password_retries] = 0
	  
      authentication_logger('no password')   
    
    # now the user has offered a password
    elsif @current_user = User.by_email_or_username( @claim ) 

        authentication_logger("coming from page '#{login_from}'")  
		authentication_logger("user #{@claim} exists")   

        # if that's ok
        if @current_user.authenticate( @password )

          authentication_logger("user authenticated")   

          # and this user is confirmed, log him in, with a new session
          if @current_user.confirmed?          

            authentication_logger("user is confirmed")   
  	       
            create_new_user_session( @current_user )	
			session[:password_retries] = nil
			session[:login_from] = nil
			authentication_logger("redirecting to page '#{login_from}'")  
            redirect_to_action_html( { notice: "#{@current_user.username} logged in" }, 
                                     login_from, (1+rand(10000)) )		                    
          else
            # else let him know he needs to activate

            authentication_logger("user is NOT confirmed")   

            redirect_to_action_html( { alert: "user is not activated, check your email (including SPAM folder)" }, 
                                           login_from )
          end
          
        else
          
          authentication_logger("authenticated problem")   

          # ok, let him try again, but only twice          
          if session[:password_retries] >= (@max_retries = MAX_RETRIES)
            
            authentication_logger('exceeded max retries - user will be suspended')  
            
            # third time... suspend the user
            @current_user.suspend_and_save
            @current_user.token = nil if @eft == 'ab47hk'
            begin
              # and send him an email
              AuthenticationNotifier.reset(@current_user, request, User.admin_emails).deliver_now           
              UserSession.clear_cookies(cookies)
			  session[:password_retries] = nil
              redirect_to_action_html( { alert: "user suspended, check your email (including SPAM folder)"},
                                             login_from )
            rescue Exception => e         
              redirect_to_action_html( { alert: "user suspended, but email sending failed 3 #{e}"},
                                             login_from )
            end
          else
            
            authentication_logger('try again')  
            
            # else try again but increment the retries (also in the session object)
            @retries = (session[:password_retries] += 1)
          end 
        end
  
    else

        authentication_logger('user not found')  

        session[:password_retries] ||= 0
        @retries = ( session[:password_retries] += 1 )
        if session[:password_retries] >= (@max_retries = MAX_RETRIES)
          redirect_to_action_html( { alert: "password for \"#{@claim}\" is incorrect!" }, 
                                           login_from )
        end
    end    

    authentication_logger('at the end of prove_it')  
    
  end

  def about_urself
    
    uncache_all

    authentication_logger('---')
    authentication_logger('start of about urself')  
    
    @username = params[:username]
    @email = params[:email] 
	if params[:answer].to_i != 0
		quiz = (params[:answer].to_i == params[:qa].to_i * params[:qb].to_i)
	else
	  quiz = false
	end
	
    # this is for testing email failure exception code
    @eft = params[:ab47hk]

    # 1) there is no :captcha parameter (when about_urself is first called up)
	# 2) else check with Google captcha what the score is (-1 if error)
    if params[:captcha]
      captcha = Captcha.verify(params[:captcha])
      @current_user_action.params = @current_user_action.params + 'captcha: ' + captcha.to_s + '; '
      @current_user_action.save  
	end
	
    # if we're already logged in
    if @current_user
      redirect_to_action_html( { alert: "#{@current_user.username} already logged in" } )
      authentication_logger("about_urself but #{@current_user.username} already logged in")   
          
    # if email and username are given...iotherwise this is the empty dialogue (first time)
    elsif @email and @username and quiz and captcha > 0.1
      # create this new user, but in unconfirmed status
      @current_user = User.new_unconfirmed( @email, @username )
      @current_user.token = nil if @eft == 'ab47hk'
      if @current_user.save 
        begin  
          path = AuthenticationNotifier.registration(@current_user,request,User.admin_emails).deliver_now  
          authentication_logger("password path #{path}")	
		  redirect_to_action_html notice: "Please check your email #{@email} (including your SPAM folder) for an email to verify it's you and set your password!"
        rescue Exception => e
          @current_user.destroy if @current_user
          redirect_to_action_html alert: "we sent an activation email, but it failed 1 (#{e})."
        end
      end
    end
    @qa = rand(4)+1
    @qb = rand(4)+1	
    
  end
  
  def from_mail # get
    
    # this is the link from the email... 
    # log out current user
    
    uncache_all
	@current_user = @current_user_session = nil
	UserSession.clear_cookies(cookies)
	
    @user_token = params[:user_token]
    @error_messages = params[:error_messages]
    if @user_token and @user_token != '' and current_user = User.by_token( @user_token )
      if !@error_messages
        flash[:notice] = "Enter new password for user \"#{current_user.username}\""
      end 
      render 
    else
      redirect_to_root_html alert: "the activation link is incorrect, please reset..."
    end      
    
  end
  
  def ur_secrets # post
      
    @user_token = params[:user_token] 
    # if we're already logged in
    if @current_user
      redirect_to_action_html( { alert: "#{@current_user.username} already logged in" } )
      authentication_logger("ur_secrets but #{@current_user.username} already logged in")
                
    # set the new password
    elsif @user_token and @user_token != '' and @current_user = User.by_token( @user_token )
	  @current_user.password = params[:kennwort]
      @current_user.password_confirmation = params[:confirmation] 
      @current_user.confirm
      @current_user.token = nil
      if @current_user.save # succes!
        create_new_user_session( @current_user )   
        redirect_to_action_html notice: "password set, you are logged in!"
      else
        redirect_to action: :from_mail, user_token: @user_token, 
		             error_messages: @current_user.errors.full_messages
      end
    elsif !@user_token or @user_token == ''
      redirect_to_action_html alert: "no token"  
	else
      redirect_to_action_html alert: "wrong token"  
    end

  end
  
  def reset_mail
    
    # reset the session object and suspend the user, with email
    UserSession.clear_cookies(cookies)
    if user = User.by_email_or_username( params[:claim] ) 
      begin
        user.suspend_and_save
        path = AuthenticationNotifier.reset(user, request, User.admin_emails).deliver_now    
        authentication_logger("password path #{path}")		
        redirect_to_root_html notice: "user #{user.username} suspended, check your email (including SPAM folder)"
      rescue Exception => e         
        redirect_to_root_html alert: "user suspended, but email sending failed 2 #{e}"
      end        
    else
      redirect_to_root_html alert: "user suspended, check your email"
    end
    
  end

  def see_u
    # reset the session object, and forget the user that way
	
	a = request.headers['HTTPREFERER']	
	session[:login_from] = a[a.rindex('/')+1..a.length] if a
    authentication_logger('see_u from #{session[:login_from]}')	
        
    UserSession.clear_cookies(cookies)
    redirect_to_root_html #  notice: "logged out"  if we keep this, then it shows up on the cached pages!
  end
       
  def check
    if params[:code].to_i == 17706
      @session = session
	else	
	  redirect_to root_path
	end
  end
  
  def clear
    UserSession.clear_cookies(cookies)
	redirect_to root_path, alert: "session reset..."
  end
         
  private
    
    def redirect_to_action_html( flash_content = nil, page = nil, upd = nil )
    
      authentication_logger('redirect_to_action_html')  

      if flash_content
        flash[ flash_content.keys[0] ] = flash_content[ flash_content.keys[0] ]
        flash.keep[ flash_content.keys[0] ]
        authentication_logger( flash[ flash_content.keys[0] ] )  
      end                 

      #
      # 
      # 
      if !upd
        redirect_to '/' + ( page || '' )
      else
        redirect_to '/' + ( page || '' ) + '?upd=' + upd.to_s
      end

    end
    
    def redirect_to_root_html( flash_content = nil )
        
      authentication_logger("redirect_to_root_html #{flash_content}")        
          
      if flash_content
        flash[ flash_content.keys[0] ] = flash_content[ flash_content.keys[0] ]
        flash.keep[ flash_content.keys[0] ]
        authentication_logger( flash[ flash_content.keys[0] ] )         
      end      
      
      redirect_to '/'
    end
    
    def create_new_user_session( user )   

      UserSession.clear_cookies(cookies)	  
      uncache_all
      user_session = UserSession.new_ip_and_client( user, request.remote_ip(),
                                                   request.env['HTTP_USER_AGENT'])
      user_session.set_cookies(cookies)
      UserAction.add_action( user_session.id, controller_name, action_name, params )        
			
    end
  
    def uncache_all
      Page.uncache_all( request.host ) if defined?( Page )
    end
    
    def authentication_logger( str )
      #
      #  uncomment to turn on logging
      logger.info( 'Logging AUTHENTICATE_CONTROLLER ' + str ) if str
      #
    end

end
