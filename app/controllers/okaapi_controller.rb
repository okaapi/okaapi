class OkaapiController < ApplicationController
  
  def index
    #if @current_user and
    #   Okaapi.unarchived_for_user( @current_user.id ).count == 0
    #  redirect_to calendar_path
    #end    
  end
    
  def termcloud 
    session[:okaapi_mode] = 'termcloud'   
    if @current_user      
      okaapis = Okaapi.unarchived_for_user( @current_user.id )
      terms = Okaapi.terms( okaapis )      
      terms = Word.unarchived_terms_not_person_for_user( @current_user.id, terms ) || {}
      @termcloud = terms.sort     
    else
      redirect_to who_are_u_path
    end    
  end
  def term_detail
    if @current_user 
      @word = Word.find_by_id( params[:word_id] )      
      @span_id = 'term_'+@word.id.to_s if @word
      @okaapis = Okaapi.for_term( @current_user.id, @word.term )
    else
      redirect_to who_are_u_path
    end
  end
  def update_okaapi
    if @current_user
      @word = Word.find_by_id( params[:word_id] )
      @okaapi = Okaapi.find( params[:okaapi_id] )
      @okaapi.subject = params[:subject]
      @okaapi.save
      redirect_to term_detail_path( word_id: @word.id )
    else
      redirect_to who_are_u_path
    end          
  end
  
  def show_okaapi_content
    if @current_user
      @okaapi = Okaapi.find( params[:id] )
    else
      redirect_to who_are_u_path
    end    
  end

  def people
    session[:okaapi_mode] = 'people' 
    if @current_user 
      @persons = Word.unarchived_people( @current_user.id )
      @people = []
      @persons.each do |person|
        okaapis = Okaapi.for_person( @current_user.id, person.term )
        @people << [ person, okaapis ] if okaapis.size > 0
      end
      @people.sort! { |a,b| a[0].term <=> b[0].term } 
    else
      redirect_to who_are_u_path
    end        
  end  
  
  def mindmap
    session[:okaapi_mode] = 'mindmap' 
    if @current_user
      okaapis = Okaapi.unarchived_for_user( @current_user.id )
      @drilldown = params[:drilldown] || []
      @mindmap = Okaapi.mindmap( @current_user.id, @drilldown || [] )
    else
      redirect_to who_are_u_path
    end         
  end
  
  def graph
    session[:okaapi_mode] = 'graph' 
    if @current_user
      okaapis = Okaapi.unarchived_for_user( @current_user.id )
      @drilldown = params[:drilldown] || []
      @graph = Okaapi.mindmap( @current_user.id, @drilldown || [] )
    else
      redirect_to who_are_u_path
    end       
  end  
  
  def toggle_person
    if @word = Word.find( params[:id] )
      @word.person = ( @word.person == 'false' ? 'true' : 'false' )
      @word.save  
    end  
    redirect_back fallback_location: root_path
  end
  def priority
    if @word = Word.find( params[:id] )
      @word.priority += params[:increment].to_i
      @word.priority = 0 if @word.priority < 0
      @word.save
    end  
    redirect_back fallback_location: root_path      
  end
  def archive_word
    if @word = Word.find( params[:id] )
      @word.archived = Time.now.utc
      @word.save      
    end
    redirect_back fallback_location: root_path
  end
  def undo_archive_word
    if @current_user
      if @word = Word.find_last_archived( @current_user.id )
        @word.archived = 'false'
        @word.save
      end
    end
    redirect_back fallback_location: root_path   
  end
  def archive_okaapi
    if @okaapi = Okaapi.find( params[:id] )
      @okaapi.archived = Time.now.utc
      @okaapi.save      
    end
    redirect_to( { action: :term_detail, word_id: params[:word_id] } )  
  end
  def undo_archive_okaapi
    if @current_user
      if @okaapi = Okaapi.find_last_archived( @current_user.id )
        @okaapi.archived = 'false'
        @okaapi.save
      end
    end
    redirect_to( { action: :term_detail, word_id: params[:word_id] } ) 
  end  
  
  def receive_okaapi_emails
    
    n = Postoffice.receive_okaapi_emails
    redirect_to '/', notice: "received #{n} okaapis"
     
  end
  
end
