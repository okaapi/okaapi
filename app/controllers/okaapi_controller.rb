class OkaapiController < ApplicationController
  
  def termcloud    
    if @user      
      new_terms = Okaapi.terms_for_user( @user.id )      
      terms = Word.unarchived_not_person_for_user( @user.id, new_terms ) || {}
      @termcloud = terms.sort        
    end    
  end
  def term_detail
    if @user 
      @word = Word.find_by_id( params[:word_id] )      
      @span_id = 'term_'+@word.id.to_s if @word
      @okaapis = Okaapi.for_term( @user.id, @word.term )
    end
  end
  def show_okaapi_content
    if @user
      @okaapi = Okaapi.find( params[:id] )
    end
  end

  def people
    if @user 
      @persons = Word.unarchived_people( @user.id )
      @people = []
      @persons.each do |person|
        @people << [ person, Okaapi.for_person( @user.id, person.term ) ]
      end
      @people.sort! { |a,b| a[0].term <=> b[0].term }
    end
  end  
  
  def mindmap
    if @user 
      new_terms = Okaapi.terms_for_user( @user.id )
      terms = Word.unarchived_not_person_for_user( @user.id, new_terms ) || {}
      terms = terms.sort {|x, y| y[1][:count] <=> x[1][:count] }
      @okaapis = Okaapi.unarchived_for_user( @user.id )
      
      @mindmap = {}
      while terms.count > 0 do
        first_term = terms.shift
        term = first_term[0]
        @mindmap[ term ] = []
        @okaapis.each do |o|
          if o.subject.downcase.index( term )
            subject_terms = o.subject.downcase.split(' ')
            subject_terms.each do |t|
              if terms.any? { |x| x[0] == t }
                @mindmap[ term ] << terms.select {|x| x[0] == t }.first               
                terms.delete_if { |x| x[0] == t }
              end
            end
          end
        end        
        @mindmap[ term ].insert( @mindmap[term].size/2, first_term )     
      end   
    end
  end
  
  def toggle_person
    if @word = Word.find( params[:id] )
      @word.person = ( @word.person == 'false' ? 'true' : 'false' )
      @word.save  
    end  
    redirect_to :back   
  end
  def priority
    if @word = Word.find( params[:id] )
      @word.priority += params[:increment].to_i
      @word.priority = 0 if @word.priority < 0
      @word.save
    end  
    redirect_to :back      
  end
  def archive_word
    if @word = Word.find( params[:id] )
      @word.archived = Time.now.utc
      @word.save      
    end
    redirect_to :back   
  end
  def undo_archive_word
    if @user
      if @word = Word.find_last_archived( @user.id )
        @word.archived = 'false'
        @word.save
      end
    end
    redirect_to :back   
  end
  def archive_okaapi
    if @okaapi = Okaapi.find( params[:id] )
      @okaapi.archived = Time.now.utc
      @okaapi.save      
    end
    redirect_to :back   
  end
  def undo_archive_okaapi
    if @user
      if @okaapi = Okaapi.find_last_archived( @user.id )
        @okaapi.archived = 'false'
        @okaapi.save
      end
    end
    redirect_to :back   
  end  
  
  def receive_okaapi_emails
    
    n = Postoffice.receive_okaapi_emails
    redirect_to '/', notice: "received #{n} okaapis"
     
  end
  
end
