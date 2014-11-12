class Okaapi < ActiveRecord::Base
  validates :user_id, :presence => true
  validate :id_valid
  before_update :garble
  after_find :ungarble 
    
  def self.lowercase_subjects_for_user( user_id )
    okaapis = Okaapi.where( user_id: user_id ).where( archived: "false" )
  end
    
  def self.terms_for_user( user_id )
    okaapis = Okaapi.where( user_id: user_id ).where( archived: "false" )
    terms = {}
    okaapis.each do |o|
      o.subject.downcase!
      o.subject.split(' ').each { |t| terms[t] = terms[t] ? terms[t] += 1 : terms[t] = 1 }
    end
    terms
  end
    
  def self.for_term( user_id, term )
    okaapis = Okaapi.where( user_id: user_id ).where( archived: "false" )
    matching_okaapis = []
    okaapis.each do |o|
      if o.subject.downcase.index( term )
        matching_okaapis << o
      end
    end
    matching_okaapis
  end  
  def self.for_person( user_id, person )
    okaapis = Okaapi.where( user_id: user_id ).where( archived: "false" )
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
    
  private

  def id_valid
    begin
      Auth::User.find(user_id)
    rescue
      errors.add( :user_id, "has to be valid")
      false
    end
  end

  def garble
    if self.g != 'false'
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
    o = ""; self.subject.each_char { |c| o << ( ( ( c.ord >= 97 and c.ord <= 122 ) or 
    ( c.ord >= 65 and c.ord <= 90 ) )  ? (187 - c.ord).chr : c ) }; self.subject = o
  end  
end
