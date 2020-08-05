require "../config/environment" unless defined?(::Rails.root)

#dbconfig = YAML::load(File.open('../config/database.yml'))
#ActiveRecord::Base.establish_connection(dbconfig["development"])

ZiteActiveRecord.site( "www.okaapi.com" )

puts Tides.get_santa_cruz_tides
