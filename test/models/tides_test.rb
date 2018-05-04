require 'test_helper'
  
class TidesTest < ActiveSupport::TestCase
  
  
  test "1" do
	water_levels = [
	  { time: DateTime.parse('5:10'), level: -0.2 },
	  { time: DateTime.parse('5:01'), level: -0.3 },
	  { time: DateTime.parse('5:02'), level: -0.4 },
	  { time: DateTime.parse('5:04'), level: -0.6 },
	  { time: DateTime.parse('5:08'), level: -0.4 },
	  { time: DateTime.parse('5:12'), level: -0.4 },
	]
	water_levels = Tides.water_level_min_max( water_levels )
  
	assert water_levels[0][:min_candidate] 
	assert !water_levels[0][:max_candidate]
	assert !water_levels[1][:min_candidate] 
	assert water_levels[1][:max_candidate]	
  end
  
  test "2" do
	water_levels = 
	[
	  { time: DateTime.parse('5:10'), level: -0.2 },
	  { time: DateTime.parse('5:01'), level: -0.3 },
	  { time: DateTime.parse('5:02'), level: -0.4 },
	  { time: DateTime.parse('5:04'), level: -0.6 },
	  { time: DateTime.parse('5:08'), level: -0.4 },
	  { time: DateTime.parse('5:12'), level: -0.4 },
	  { time: DateTime.parse('5:11'), level: -0.2 },
	  { time: DateTime.parse('5:05'), level: -0.6 },
	]
    water_levels = Tides.water_level_min_max( water_levels )	
	assert water_levels[0][:min_candidate] 
	assert !water_levels[0][:max_candidate]
	assert !water_levels[1][:min_candidate] 
	assert water_levels[1][:max_candidate]	
  end
  
  test "3" do
	water_levels =
	[
	  { time: DateTime.parse('5:10'), level: -0.2 },
	  { time: DateTime.parse('5:01'), level: -0.3 },
	  { time: DateTime.parse('5:02'), level: -0.4 },
	  { time: DateTime.parse('5:04'), level: -0.6 },
	  { time: DateTime.parse('5:08'), level: -0.4 },
	  { time: DateTime.parse('5:12'), level: -0.4 },
	  { time: DateTime.parse('5:13'), level: -0.5 },
	  { time: DateTime.parse('5:00'), level: -0.2 },
	]
	water_levels = Tides.water_level_min_max( water_levels )
	assert water_levels[0][:min_candidate] 
	assert !water_levels[0][:max_candidate]
	assert !water_levels[1][:min_candidate] 
	assert water_levels[1][:max_candidate]	
  end

end
