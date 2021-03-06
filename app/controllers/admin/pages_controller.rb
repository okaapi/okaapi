
module Admin

	class PagesController < ApplicationController
	
	  before_action :set_page, only: [:show, :edit, :update, :destroy]
	  before_action :only_if_admin
	  
	  # GET /pages
	  # GET /pages.json
	  def index
	    if params[:by_name]
              @pages = Page.all.order( name: :asc, updated_at: :desc ).order( name: :asc )       
	    elsif params[:most_recent_only]
              sql = "select id from pages where (name, updated_at) in " +
                "(select name, max(updated_at) from pages where site = '#{ZiteActiveRecord.site?}'" +
                " group by name) " + "order by name asc;"
              @pages = []
              results = ActiveRecord::Base.connection.execute(sql)   
              results.each do |r|
                @pages << Page.find( r[0] )
              end
	    else
              @pages = Page.all.order( updated_at: :desc )
	    end	    
	  end
	
	  # GET /pages/1
	  # GET /pages/1.json
	  def show
	  end
	
	  # GET /pages/new
	  def new
	    @page = Page.new
	  end
	
	  # GET /pages/1/edit
	  def edit
	  end
	
	  # POST /pages
	  # POST /pages.json
	  def create
	    @page = Page.new(page_params)
	
	    respond_to do |format|
	      if @page.save
	        format.html { redirect_to @page, notice: 'Page was successfully created.' }
	        format.json { render :show, status: :created, location: @page }
	      else
	        format.html { render :new }
	        format.json { render json: @page.errors, status: :unprocessable_entity }
	      end
	    end
	  end
	
	  # PATCH/PUT /pages/1
	  # PATCH/PUT /pages/1.json
	  def update
	    respond_to do |format|
	      if @page.update(page_params)
	        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
	        format.json { render :show, status: :ok, location: @page }
	      else
	        format.html { render :edit }
	        format.json { render json: @page.errors, status: :unprocessable_entity }
	      end
	    end
	  end
	
	  # DELETE /pages/1
	  # DELETE /pages/1.json
	  def destroy
	    @page.destroy
	    respond_to do |format|
	      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
	      format.json { head :no_content }
	    end
	  end
	
	  private
	    # Use callbacks to share common setup or constraints between actions.
	    def set_page
	      @page = Page.where(id: params[:id]).take
	    end
	
	    # Never trust parameters from the scary internet, only allow the white list through.
	    def page_params
	      params.require(:page).permit(:content, :name, :user_id, :visibility, :editability, :menu, :lock)
	    end
	end

end
