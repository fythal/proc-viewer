class ProceduresController < ApplicationController
  before_action :set_procedure, only: [:show, :edit, :update, :destroy]
  before_action :set_ann, only: [:show, :create]

  # GET /procedures
  # GET /procedures.json
  def index
    @procedures = Procedure.all
  end

  # GET /procedures/1
  # GET /procedures/1.json
  def show
  end

  # GET /procedures/new
  def new
    @procedure = Procedure.new
    @ann = Ann.find(params[:ann_id]) if params[:ann_id]
  end

  # GET /procedures/1/edit
  def edit
  end

  # POST /procedures
  # POST /procedures.json
  def create
    @procedure = Procedure.new(procedure_params.merge({:ann_id => @ann.to_param}))

    if params[:procedure][:file]
      @procedure.write(params[:procedure][:file])
    end

    respond_to do |format|
      if @procedure.save
        format.html do
          if @ann
            redirect_to [@ann, @procedure], notice: 'Procedure was successfully created.'
          else
            redirect_to @procedure, notice: 'Procedure was successfully created.'
          end
        end
        format.json { render action: 'show', status: :created, location: @procedure }
      else
        format.html { render action: 'new' }
        format.json { render json: @procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /procedures/1
  # PATCH/PUT /procedures/1.json
  def update
    respond_to do |format|
      if @procedure.update(procedure_params)
        format.html { redirect_to @procedure, notice: 'Procedure was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @procedure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /procedures/1
  # DELETE /procedures/1.json
  def destroy
    @procedure.destroy
    respond_to do |format|
      format.html { redirect_to procedures_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_procedure
    @procedure = Procedure.find(params[:id])
  end

  def set_ann
    @ann = (params[:ann_id] ? Ann.find(params[:ann_id]) : nil)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def procedure_params
    params.require(:procedure).permit(:revision, :revised_on, :prev_revision_id)
  end
end
