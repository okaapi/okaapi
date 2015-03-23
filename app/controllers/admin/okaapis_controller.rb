module Admin
class OkaapisController < ApplicationController
  before_action :set_okaapi, only: [:show, :edit, :update, :destroy]
  before_action :only_if_admin
  
  # GET /okaapis
  # GET /okaapis.json
  def index
    @okaapis = Okaapi.all
  end

  # GET /okaapis/1
  # GET /okaapis/1.json
  def show
  end

  # GET /okaapis/new
  def new
    @okaapi = Okaapi.new
  end

  # GET /okaapis/1/edit
  def edit
  end

  # POST /okaapis
  # POST /okaapis.json
  def create
    @okaapi = Okaapi.new(okaapi_params)

    respond_to do |format|
      if @okaapi.save
        format.html { redirect_to @okaapi, notice: 'Okaapi was successfully created.' }
        format.json { render :show, status: :created, location: @okaapi }
      else
        format.html { render :new }
        format.json { render json: @okaapi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /okaapis/1
  # PATCH/PUT /okaapis/1.json
  def update
    respond_to do |format|
      if @okaapi.update(okaapi_params)
        format.html { redirect_to @okaapi, notice: 'Okaapi was successfully updated.' }
        format.json { render :show, status: :ok, location: @okaapi }
      else
        format.html { render :edit }
        format.json { render json: @okaapi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /okaapis/1
  # DELETE /okaapis/1.json
  def destroy
    @okaapi.destroy
    respond_to do |format|
      format.html { redirect_to okaapis_url, notice: 'Okaapi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def upload
    
    if @current_user
      uploaded_file = params[:file]
      file_content = uploaded_file.read
      lines = file_content.split("\n")
      lines.each do |line|
        values = line.split(";")
        parameters = {}
        values.each do |v|
          key = v.split(': ')[0].strip
          value = v.split(': ')[1]
          parameters[key] = value;        
        end
        parameters.symbolize_keys!
        parameters[:user_id] = @current_user.id
        okaapi = Okaapi.create( parameters.symbolize_keys )   
        okaapi.save!
      end
    end
    respond_to do |format|
      format.html { redirect_to okaapis_url, notice: 'File was successfully parsed...' }
      format.json { head :no_content }
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_okaapi
      @okaapi = Okaapi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def okaapi_params
      params.require(:okaapi).permit(:subject, :content, :time, :from, :reminder, :archived, :user_id)
    end
end
end
