# -*- coding: utf-8 -*-
class AnnsController < ApplicationController
  before_action :set_ann, only: [:show, :edit, :update, :destroy]

  # GET /anns
  # GET /anns.json
  def index
    keyword = params[:keyword]
    if keyword.nil?
      @anns = Ann.all
    else
      @anns = Ann.where("name like ?", "%#{keyword}%")
    end
  end

  # GET /anns/1
  # GET /anns/1.json
  def show
  end

  # GET /anns/new
  def new
    @ann = Ann.new
  end

  # GET /anns/1/edit
  def edit
  end

  # POST /anns
  # POST /anns.json
  def create
    @ann = Ann.new(ann_params)
    @ann.assign(panel: panel_params[:panel_number], location: panel_params[:panel_location])
    @panel = @ann.panel

    respond_to do |format|
      if @ann.save

        if procedure_params[:procedure]
          # 手順書についての処理
          uploaded = procedure_params[:procedure]
          path = File.join('/procs', uploaded.original_filename.to_s + Time.now.strftime('-%Y-%m-%d-%H_%M_%S') + ".pdf").to_s
          procedure = Procedure.new(path: path, ann: @ann)
          File.open(procedure.file_path, "wb") do |file|
            file.write(uploaded.read)
          end
          procedure.save
        end

        format.html { redirect_to @ann, notice: 'Ann was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ann }
      else
        format.html { render action: 'new' }
        format.json { render json: @ann.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anns/1
  # PATCH/PUT /anns/1.json
  def update
    if panel_params[:panel_number] and panel_params[:panel_number]
      if @ann.assign(panel: panel_params[:panel_number], location: panel_params[:panel_location])
        @panel = @ann.panel
      end
    end

    respond_to do |format|
      if @ann.update(ann_params)
        format.html { redirect_to @ann, notice: 'Ann was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ann.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /anns/1
  # DELETE /anns/1.json
  def destroy
    @ann.destroy
    respond_to do |format|
      format.html { redirect_to anns_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ann
    @ann = Ann.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ann_params
    params.require(:ann).permit(:name, :pdf, :panel)
  end

  def panel_params
    params.require(:ann).permit(:panel_number, :panel_location)
  end

  def procedure_params
    params.require(:ann).permit(:procedure)
  end
end
