# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Auth::User.create( id: 11, username: 'wido', email: 'wido@menhardt.com', active: 'confirmed',
                           password: 'wido', password_confirmation: 'wido')
                                                        
(10..20).each do |i|                           
  DiaryEntry.create( date: "", day: i.to_s, month: 10, year: 2014, content: "test entry for day #{i}", user_id: 11 ) 
  puts "."; sleep( 1 )
end

DiaryEntry.create( date: "", day: 13, month: 10, year: 2014, content: "2nd test entry for day 13", user_id: 11 )
puts "."; sleep( 1 )
DiaryEntry.create( date: "", day: 19, month: 10, year: 2014, content: "2nd test entry for day 19", user_id: 11 )
puts "."; sleep( 1 )
DiaryEntry.create( date: "", day: 19, month: 10, year: 2014, content: "3rd test entry for day 19", user_id: 11 )
puts "."; sleep( 1 )          
DiaryEntry.create( date: "", day: 20, month: 10, year: 2014, content: "2nd test entry for day 20", user_id: 11 )
puts "."; sleep( 1 )         
DiaryEntry.create( date: "", day: 21, month: 10, year: 2014, archived: "true", content: "archived entry", user_id: 11 )
puts "."; sleep( 1 )    

Okaapi.create( user_id: 11, subject: "red blue green" )
Okaapi.create( user_id: 11, subject: "red blue purple" )
Okaapi.create( user_id: 11, subject: "red purple gray" )
Okaapi.create( user_id: 11, subject: "black white" )

                             
                             
