require "../../config/environment" unless defined?(::Rails.root)

require 'net/http'
require 'json'

def water_level_min_max( water_levels )
  water_levels[0][:min_candidate] = water_levels[0][:max_candidate] = false
  water_levels[water_levels.length-1][:min_candidate] = water_levels[water_levels.length-1][:max_candidate] = false
  (0..water_levels.length-1).each do |i|
    if i > 0
      if water_levels[i][:level] < water_levels[i-1][:level]
        water_levels[i][:max_candidate] = false
      end
      if water_levels[i][:level] > water_levels[i-1][:level]
        water_levels[i][:min_candidate] = false
      end      
    end
    if i < water_levels.length-1
      if water_levels[i][:level] < water_levels[i+1][:level]
        water_levels[i][:max_candidate] = false
      end
      if water_levels[i][:level] > water_levels[i+1][:level]
        water_levels[i][:min_candidate] = false
      end      
    end            
  end
  (0..water_levels.length-2).each do |i|
    if water_levels[i][:max_candidate] && water_levels[i+1][:max_candidate]
      water_levels[i][:max_candidate] = false
    end
    if water_levels[i][:min_candidate] && water_levels[i+1][:min_candidate]
      water_levels[i][:min_candidate] = false
    end               
  end  
  (0..water_levels.length-1).each do |i|
    if !water_levels[i][:min_candidate] && !water_levels[i][:max_candidate]
      water_levels[i] = nil
    end
  end  
  water_levels.compact
end

water_levels = [
{ time: '5:00', level: -1, min_candidate: false, max_candidate: false }
]


=begin
  today = Time.now
  td = today.strftime("%Y%m%d")
  url = "https://tidesandcurrents.noaa.gov/api/datagetter?" + 
        "begin_date=#{td}&end_date=#{td}&" + 
        "station=9413450&time_zone=lst_ldt&product=predictions&datum=MLLW&units=english&time_zone=lst&format=json"
                     
  uri = URI(url) 
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  req = Net::HTTP::Get.new(uri.path+'?'+uri.query)

  p uri.host
  p uri.portl
  p uri.path
  p uri.query
  res = http.request(req)
  res = JSON.parse(res.body)
  predictions = res['predictions']
  
  water_levels = []
  predictions.each_with_index do |hash,i|
    t = Time.parse( hash['t'] )
    water_levels[i] = { time: t.strftime("%I:%M%p" ), 
                        level: hash['v'].to_f, max_candidate: true, min_candidate: true }
  end
  
  water_levels = water_level_min_max( water_levels )
  
  answer = "On #{today.strftime("%A %e %B")}: "
  (0..water_levels.length-1).each do |i|
    if water_levels[i][:max_candidate]
      answer += "There is high of #{water_levels[i][:level].round(1)} feet at #{water_levels[i][:time]}. "
      #puts "time #{water_levels[i][:time]} level #{water_levels[i][:level]}  HIGH"
    elsif water_levels[i][:min_candidate]   
      answer += "There is low of #{water_levels[i][:level].round(1)} feet at #{water_levels[i][:time]}. "
      #puts "time #{water_levels[i][:time]} level #{water_levels[i][:level]}  LOW"
    else
      #puts "time #{water_levels[i][:time]} level #{water_levels[i][:level]}"    
    end
  end
  puts answer
=end  
  
