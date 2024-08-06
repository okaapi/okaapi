require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'net/http'
require 'json'

ZiteActiveRecord.site( "www.okaapi.com" )

diary_entries = DiaryEntry.all

diary_entries.each do |d|

  if d.year >= 2023 
    #puts ""
    #puts d.day.to_s + ' ' + d.month.to_s + ' ' + d.year.to_s + ' ' + d.id.to_s
    content = d.content.gsub(/\n/,"").gsub(/\r/,"")
    #p content
    content.gsub!(/On(?:(?!On).)*?wrote:/m, '')
    content.gsub!(/Am(?:(?!Am).)*?>:/m, '')
    #temporary
    content.gsub!(/Am(?:(?!Am).)*?.com:/m, '')

    content.squeeze!('>')
    content.gsub!(/<>/, '')
    content.gsub!(/> >/, '>')
    content.gsub!(/^\s*>/,'')
    content.gsub!(/>$/,'')
    content.strip!
    d.content = content
    #p d.content
    d.save!
  end
  
end

(2023..2024).each do |y|
  (1..12).each do |m|
    (1..31).each do |d|
      diary_entries = DiaryEntry.where( year: y, month: m, day: d).order('content')
      if diary_entries.count > 1
        puts ">>>>"
        puts ""
        puts d.to_s + ' ' + m.to_s + ' ' + y.to_s
        diary_entries.each do |e|
          p e.id.to_s + " " + e.content
        end
        #diary_entries.each do |e|
        #  if e.id != diary_entries.first.id and e.content == diary_entries.first.content
        #    p "delete f " + e.id.to_s + " "  + e.content
        #    gets
        #    e.delete
        #  end
        #end
        diary_entries.each do |e|
          if e.id != diary_entries.last.id and e.content == diary_entries.last.content
            p "delete l " + e.id.to_s + " "  + e.content
            gets
            e.delete
          end
        end
      end
    end
  end
end
