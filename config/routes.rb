Rails.application.routes.draw do
  
  mount Auth::Engine => "/", as: "auth_engine"

  root "application#index", as: "root"

  get 'diary/calendar', as: "calendar"
  get 'diary/send_diary_email', as: "send_diary_email"
  get 'diary/send_all_diary_emails/:token' => 'diary#send_all_diary_emails', as: "send_all_diary_emails"
  get 'diary/receive_diary_emails', as: "receive_diary_emails"  
  get 'diary/turn_off_diary_emails', as: "turn_off_diary_emails"
  
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
  
  resources :okaapis
  post 'okaapis/upload'
  resources :words
  resources :reminders
  resources :diary_entries  
  post 'diary_entries/upload'  

end
