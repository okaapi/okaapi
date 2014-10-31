json.array!(@okaapis) do |okaapi|
  json.extract! okaapi, :id, :subject, :content, :time, :from, :reminder, :archived, :user_id
  json.url okaapi_url(okaapi, format: :json)
end
