class Tides 

  def self.get_santa_cruz_tides
    water_levels = Tides.get_predictions_from_noaa
    water_levels = Tides.water_level_min_max( water_levels ) 
    Tides.parse_water_levels( water_levels )
  end
  
  def self.get_predictions_from_noaa
	  today = Time.now
	  td = today.strftime("%Y%m%d")
	  url = "https://tidesandcurrents.noaa.gov/api/datagetter?" + 
	        "begin_date=#{td}&end_date=#{td}&" + 
	        "station=9413450&time_zone=lst_ldt&product=predictions&datum=MLLW&units=english&time_zone=lst&format=json"
	                     
	  uri = URI(url) 
	  http = Net::HTTP.new(uri.host, uri.port)
	  http.use_ssl = true
	  req = Net::HTTP::Get.new(uri.path+'?'+uri.query)
	
	  res = http.request(req)
	  res = JSON.parse(res.body)
	  predictions = res['predictions']
	  
	  water_levels = []
	  predictions.each_with_index do |hash,i|
	    t = Time.parse( hash['t'] )
	    water_levels[i] = { time: t, 
	                        level: hash['v'].to_f }
	  end
	  water_levels
  end
  
  def self.parse_water_levels( water_levels )
      today = Time.now
	  answer = "On #{today.strftime("%A %e %B")}: "
	  (0..water_levels.length-1).each do |i|
	    if water_levels[i][:max_candidate]
	      answer += "There is a high of #{water_levels[i][:level].round(1)} feet " +
	                "at #{water_levels[i][:time].strftime("%I:%M%p")}. "
	    elsif water_levels[i][:min_candidate]   
	      answer += "There is a low of #{water_levels[i][:level].round(1)} feet " + 
	                "at #{water_levels[i][:time].strftime("%I:%M%p")}. "
	    end
	  end
	  answer
  end
  
  def self.water_level_min_max( water_levels )
	  water_levels.sort! { |x,y| x[:time] <=> y[:time] }

	  (0..water_levels.length-1).each do |i|
	    water_levels[i][:min_candidate] = water_levels[i][:max_candidate] = true
	    if i > 0
	      if water_levels[i][:level] < water_levels[i-1][:level]
	        water_levels[i][:max_candidate] = false
	      end
	      if water_levels[i][:level] > water_levels[i-1][:level]
	        water_levels[i][:min_candidate] = false
	      end      
	    end
	    if i < water_levels.length-1
	      if water_levels[i][:level] <= water_levels[i+1][:level]
	        water_levels[i][:max_candidate] = false
	      end
	      if water_levels[i][:level] >= water_levels[i+1][:level]
	        water_levels[i][:min_candidate] = false
	      end      
	    end            
	  end
	  
	  water_levels[0][:min_candidate] = water_levels[0][:max_candidate] = false
	  water_levels[water_levels.length-1][:min_candidate] = water_levels[water_levels.length-1][:max_candidate] = false  
	  (0..water_levels.length-1).each do |i|
	    if !water_levels[i][:min_candidate] && !water_levels[i][:max_candidate]
	      water_levels[i] = nil
	    end
	  end  
  
	  water_levels.compact
  end
	
end
