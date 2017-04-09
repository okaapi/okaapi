

if system('wget https://www.menhardt.com -O /dev/null')
  puts "menhardt.com ok"
else
  puts "menhardt.com problems"
end

puts
puts

if system('wget http://208.74.182.86:50000 -O /dev/null')
  puts "menhardt panasonic camera ok"
else
  puts "menhardt panasonic camera NOT ok"
end

puts
puts

