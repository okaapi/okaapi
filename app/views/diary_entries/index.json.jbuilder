json.array!(@diary_entries) do |diary_entry|
  json.extract! diary_entry, :id, :entry, :day, :month, :year, :archived, :user_id
  json.url diary_entry_url(diary_entry, format: :json)
end
