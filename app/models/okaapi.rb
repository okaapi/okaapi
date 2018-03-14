require 'pp'

class Okaapi < ActiveRecord::Base
  validates :user_id, :presence => true
  validate :id_valid
  before_save :garble
  after_save :ungarble  
  after_find :ungarble 
    
  def self.unarchived_for_user( user_id )
    os = Okaapi.where( user_id: user_id ).where( archived: "false" )
    okaapis = []
    os.each { |o| okaapis << o }
  end
    
  def self.terms( okaapis )
    terms = {}
    okaapis.each do |o|
      o.subject.downcase!
      o.subject.split(' ').each { |t| terms[t] = terms[t] ? terms[t] += 1 : terms[t] = 1 }
    end
    terms
  end
    
  def self.for_term( user_id, term )
    okaapis = Okaapi.unarchived_for_user( user_id )
    matching_okaapis = []
    okaapis.each do |o|
      if o.subject.downcase.index( term )
        matching_okaapis << o
      end
    end
    matching_okaapis
  end  
  
  def self.for_person( user_id, person )
    okaapis = Okaapi.unarchived_for_user( user_id )
    matching_okaapis = []
    okaapis.each do |o|
      ppls = o.subject.downcase.split(' ')
      ppls.each do |p|
        if p == person
          matching_okaapis << o
        end
      end
    end
    matching_okaapis
  end
  
  def self.find_last_archived( user_id )
    Okaapi.where( user_id: user_id).where.not( archived: 'false').order( archived: :desc ).first    
  end
    
  def self.mindmap( user_id, mindlimits = [] )
    okaapis = Okaapi.unarchived_for_user( user_id ).dup
	
    mindlimits.each do |limit|
      okaapis.delete_if{ |o| ! (o.subject.downcase.index( limit )) }
    end
          
    terms = Okaapi.terms( okaapis )          
    terms = Word.unarchived_terms_not_person_for_user( user_id, terms ) || {}
    terms = terms.sort do |x, y| 
      if y[1][:count] == x[1][:count]
        x[0] <=> y[0]
      else
        y[1][:count] <=> x[1][:count]
      end
    end 
    
    mindlimits.each do |limit|
      terms.delete_if{ |t| t[0] == limit }
    end    
    
    mindmap = {}
    while terms.count > 0 do
      first_term = terms.shift
      term = first_term[0]
      mindmap[ term ] = []
      okaapis.each do |o|
        if o.subject.downcase.index( term )
          subject_terms = o.subject.downcase.split(' ')
          subject_terms.each do |t|
            if terms.any? { |x| x[0] == t }
              mindmap[ term ] << terms.select {|x| x[0] == t }.first               
              terms.delete_if { |x| x[0] == t }
            end
          end
        end
      end      
      mindmap[ term ].insert( mindmap[term].size/2, first_term )
    end 

    return mindmap
  end
  
  private

  def id_valid
    begin
      User.find(user_id)
    rescue
      errors.add( :user_id, "has to be valid")
      false
    end
  end

  def garble
    if self.g != 'true'
      grieb
      self.g = 'true'
    end
  end
  def ungarble
    if self.g == 'true'
      grieb
      self.g = 'false'
    end
  end
  
  def grieb
    self.subject ||= ''
    o = ""; self.subject.each_char { |c| o << ( ( ( c.ord >= 97 and c.ord <= 122 ) or 
    ( c.ord >= 65 and c.ord <= 90 ) )  ? (187 - c.ord).chr : c ) }; self.subject = o
  end  
end
