Rails.application.routes.draw do
  
  # these are the actions related to authentication
  get "_who_are_u" => "authenticate#who_are_u", as: 'who_are_u'
  match "_prove_it" => "authenticate#prove_it", as: 'prove_it', via: [:get, :post] 
  match "_about_urself" => "authenticate#about_urself", as: 'about_urself', via: [:get, :post] 
  get "_from_mail/(:user_token)" => "authenticate#from_mail", as: 'from_mail'
  match "_ur_secrets" => "authenticate#ur_secrets", as: "ur_secrets", via: [:get, :post] 
  get "_reset_mail" => "authenticate#reset_mail", as: 'reset_mail'
  get "_see_u" => "authenticate#see_u", as: 'see_u'
  #get 'testfb' => "authenticate#testfb", as: 'testfb'  
  #get '_fb_login/:fb_token' => "authenticate#fb_login", as: 'fb_login'
  get '_check/(:code)' => 'authenticate#check', as: 'check'  
  get '_clear' => 'authenticate#clear', as: 'clear'   
      
  # these should only be available to administrators...
  scope module: 'admin' do  
  
    # for authentication
    resources :users
    get 'users/:id/role_change/:role' => 'users#role_change', as: 'role_change'
    resources :user_actions
    resources :user_sessions  
    get 'stats' => 'user_sessions#stats', as: 'stats'
	get 'purge_sessions' => 'user_sessions#purge_sessions', as: 'purge_sessions'  
    resources :site_maps  

    # for administration 
    resources :words
    resources :okaapis  
    resources :diary_entries      
    post 'okaapis/upload'
    post 'diary_entries/upload'      
  end  
 
  get 'calendar' => 'diary#calendar', as: "calendar"
  get 'diary/send_diary_email', as: "send_diary_email"
  get 'diary/send_all_diary_emails/:token' => 'diary#send_all_diary_emails', as: "send_all_diary_emails"
  get 'diary/receive_diary_emails', as: "receive_diary_emails"  
  get 'diary/turn_off_diary_emails', as: "turn_off_diary_emails"
  get 'diary/show_entry', as: "show_diary_entry"
  get 'diary/show_tag', as: "show_diary_tag"  
  post 'diary/update_entry', as: "update_diary_entry"  
  
  get 'okaapi/termcloud', as: "termcloud"
  get 'okaapi/mindmap', as: "mindmap"
  get 'okaapi/people', as: "people"
  get 'okaapi/graph' , as: "graph"  
  get 'okaapi/term_detail', as: "term_detail"  
  post 'okaapi/update_okaapi', as: "update_okaapi"
  get 'okaapi/toggle_person', as: "toggle_person"
  get 'okaapi/priority', as: "priority"
  get 'okaapi/archive_word', as: "archive_word"
  get 'okaapi/undo_archive_word', as: "undo_archive_word"
  get 'okaapi/archive_okaapi', as: "archive_okaapi"
  get 'okaapi/undo_archive_okaapi', as: "undo_archive_okaapi"
  get 'okaapi/show_okaapi_content', as: "show_okaapi_content"
  get 'okaapi/send_okaapi_emails', as: "send_okaapi_emails"
  get 'okaapi/receive_okaapi_emails', as: "receive_okaapi_emails"

  # alexa
  match 'movie_theatre_on' => "alexa#movie_theatre_on",
        as: 'movie_theatre_on', via: [:get, :post] 
  match 'movie_theatre_off' => "alexa#movie_theatre_off",
        as: 'movie_theatre_off', via: [:get, :post] 
  get 'movie_theatre_status' => "alexa#movie_theatre_status",
        as: 'movie_theatre_status'
  match 'shopping' => "alexa#shopping", as: 'shopping', via: [:get, :post] 
  
  root "okaapi#index", as: "root"
  
  match '*path' => 'okaapi#index', via: [:get, :post] 

end
