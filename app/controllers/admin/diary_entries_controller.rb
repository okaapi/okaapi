module Admin

class DiaryEntriesController < ApplicationController
  before_action :set_diary_entry, only: [:show, :edit, :update, :destroy]
  before_action :only_if_admin
  
  # GET /diary_entries
  # GET /diary_entries.json
  def index
    @diary_entries = DiaryEntry.all
  end

  # GET /diary_entries/1
  # GET /diary_entries/1.json
  def show
  end

  # GET /diary_entries/new
  def new
    @diary_entry = DiaryEntry.new
  end

  # GET /diary_entries/1/edit
  def edit
  end

  # POST /diary_entries
  # POST /diary_entries.json
  def create
    @diary_entry = DiaryEntry.new(diary_entry_params)

    respond_to do |format|
      if @diary_entry.save
        format.html { redirect_to @diary_entry, notice: 'Diary entry was successfully created.' }
        format.json { render :show, status: :created, location: @diary_entry }
      else
        format.html { render :new }
        format.json { render json: @diary_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /diary_entries/1
  # PATCH/PUT /diary_entries/1.json
  def update
    respond_to do |format|
      if @diary_entry.update(diary_entry_params)
        format.html { redirect_to @diary_entry, notice: 'Diary entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @diary_entry }
      else
        format.html { render :edit }
        format.json { render json: @diary_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /diary_entries/1
  # DELETE /diary_entries/1.json
  def destroy
    @diary_entry.destroy
    respond_to do |format|
      format.html { redirect_to diary_entries_url, notice: 'Diary entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
    
    if @current_user
      uploaded_file = params[:file]
      file_content = uploaded_file.read
      lines = file_content.split("\n")

      lines.each do |line|        
        # split line in key/value pairs
        values = line.strip.split(";")        
        parameters = {}
        values.each do |v|
          key = v.split(': ')[0].strip
          value = v.split(': ')[1]
          value.gsub!(/\"/,'')
          parameters[key] = value;       
        end
        # prepare symbols for DiaryEntry create call   
        parameters.symbolize_keys!
        parameters[:user_id] = @current_user.id
        entry = DiaryEntry.create( parameters.symbolize_keys )   
        entry.save!
      end
    end
    respond_to do |format|
      format.html { redirect_to diary_entries_url, notice: 'File was successfully parsed...' }
      format.json { head :no_content }
    end   
     
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diary_entry
      @diary_entry = DiaryEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diary_entry_params
      params.require(:diary_entry).permit(:content, :day, :month, :year, :archived, :user_id)
    end
end

end
