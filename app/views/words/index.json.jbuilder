json.array!(@words) do |word|
  json.extract! word, :id, :term,, :priority, :person,, :archived,, :user_id
  json.url word_url(word, format: :json)
end
