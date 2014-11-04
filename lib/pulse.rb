
if /200/ =~ system('wget menhardt.com -O /dev/null')
  puts "menhardt.com ok"
else
  puts "menhardt.com problems"
end
if /200/ =~ ssystem('wget http://208.74.182.86:50000 -O /dev/null')
  puts "menhardt panasonic camera ok"
else
  puts "menhardt panasonic camera NOT ok"
end
