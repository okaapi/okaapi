class Word < ActiveRecord::Base
  validates :user_id, :presence => true
  validate :id_valid
   
  def self.unarchived_terms_not_person_for_user( user_id, terms = nil  )
    
    return if not terms
    
    words = Word.where( user_id: user_id )
    
    return_terms = {}
    terms.each do |t,count|
      term = t.downcase
      word = words.where( term: term ).first
      if !word
        word = Word.create( user_id: user_id, term: term )        
        return_terms[ term ] = { count: count, priority: 1, word_id: word.id }
      else
        unless word.person == 'true' or word.archived != 'false'
          return_terms[ term ] = { count: count, priority: word.priority, word_id: word.id }
        end
      end
    end
    return return_terms
    
  end
  
  def self.unarchived_people( user_id )
    words = Word.where( user_id: user_id ).where( archived: 'false').where.not( person: 'false')
  end
  
  def self.find_last_archived( user_id )
    Word.where( user_id: user_id).where.not( archived: 'false').order( archived: :desc ).first    
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
  
end
