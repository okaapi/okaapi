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
    @okaapi = Okaapi.find( params[:id] )
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
    
    @new_entries = OkaapiMailer.get_okaapis
    @new_entries.each do |entry|
      if user = Auth::User.where( email: entry[:from] ).first
        ok = Okaapi.new( entry )
        ok.user_id = user.id
        ok.save!
      end
    end
    redirect_to :back
     
  end
  
end
