Rails.application.routes.draw do
  
  # these are the actions related to authentication
  get "_who_are_u" => "authenticate#who_are_u", as: 'who_are_u'
  post "_prove_it" => "authenticate#prove_it", as: 'prove_it'
  post "_about_urself" => "authenticate#about_urself", as: 'about_urself'
  get "_from_mail/(:user_token)" => "authenticate#from_mail", as: 'from_mail'
  post "_ur_secrets" => "authenticate#ur_secrets", as: "ur_secrets", as: 'ur_secrets'
  get "_reset_mail" => "authenticate#reset_mail", as: 'reset_mail'
  get "_see_u" => "authenticate#see_u", as: 'see_u'
    
  # these should only be available to administrators...
  scope module: 'admin' do  
    resources :users
    resources :user_actions
    resources :user_sessions   
    resources :words
    resources :okaapis  
    resources :diary_entries      
    post 'okaapis/upload'
    post 'diary_entries/upload'      
  end  
  


  get 'diary/calendar', as: "calendar"
  get 'diary/send_diary_email', as: "send_diary_email"
  get 'diary/send_all_diary_emails/:token' => 'diary#send_all_diary_emails', as: "send_all_diary_emails"
  get 'diary/receive_diary_emails', as: "receive_diary_emails"  
  get 'diary/turn_off_diary_emails', as: "turn_off_diary_emails"
  get 'diary/show_entry', as: "show_diary_entry"
  
  get 'okaapi/termcloud', as: "termcloud"
  get 'okaapi/mindmap', as: "mindmap"
  get 'okaapi/people', as: "people"
  get 'okaapi/term_detail', as: "term_detail"  
  get 'okaapi/toggle_person', as: "toggle_person"
  get 'okaapi/priority', as: "priority"
  get 'okaapi/archive_word', as: "archive_word"
  get 'okaapi/undo_archive_word', as: "undo_archive_word"
  get 'okaapi/archive_okaapi', as: "archive_okaapi"
  get 'okaapi/undo_archive_okaapi', as: "undo_archive_okaapi"
  get 'okaapi/show_okaapi_content', as: "show_okaapi_content"
  get 'okaapi/send_okaapi_emails', as: "send_okaapi_emails"
  get 'okaapi/receive_okaapi_emails', as: "receive_okaapi_emails"
  


  
  root "application#index", as: "root"

end
