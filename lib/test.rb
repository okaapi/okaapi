

def grieb( s )
  o = ""; s.each_char { |c| o << ( ( ( c.ord >= 97 and c.ord <= 122 ) or 
  ( c.ord >= 65 and c.ord <= 90 ) )  ? (187 - c.ord).chr : c ) }; o
end

string = "wido MENHARDT"
p grieb( string )
p grieb( grieb( string ) )
