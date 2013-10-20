# -*- coding: utf-8 -*-
class PanelsController < ApplicationController
  before_action :set_super_panel, only: [:create, :update]
  before_action :set_panel, only: [:show, :edit, :update, :destroy]
  before_action :fetch_all_boards, only: [:index, :new, :edit]

  skip_before_action :identify_user

  # GET /panels
  # GET /panels.json
  def index
    @panels = Panel.all
  end

  # GET /panels/1
  # GET /panels/1.json
  def show
  end

  # GET /panels/new
  def new
    @panel = Panel.new
  end

  # GET /panels/1/edit
  def edit
  end

  # POST /panels
  # POST /panels.json
  def create
    @panel = Panel.new(panel_params)
    if @super_panel
      @super_panel.assign(@panel, to: params[:panel][:panel_location])
    end

    respond_to do |format|
      if @panel.save
        format.html { redirect_to @panel, notice: 'Panel was successfully created.' }
        format.json { render action: 'show', status: :created, location: @panel }
      else
        format.html { render action: 'new' }
        format.json { render json: @panel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /panels/1
  # PATCH/PUT /panels/1.json
  def update
    @super_panel.assign(@panel, to: location) if @super_panel.present?

    respond_to do |format|
      if @panel.update(panel_params)
        format.html { redirect_to @panel, notice: 'Panel was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @panel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /panels/1
  # DELETE /panels/1.json
  def destroy
    @panel.destroy
    respond_to do |format|
      format.html { redirect_to panels_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_panel
      @panel = Panel.find(params[:id])
    end

    def set_super_panel
      return unless params_for_subpanel?

      unless params[:panel][:panel_number].blank?
        @super_panel = Panel.find_or_initialize_by(number: params[:panel][:panel_number])
      end
    end

    def fetch_all_boards
      @boards = Board.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def panel_params
      params.require(:panel).permit(:number, :width, :height, :board_id)
    end

    def params_for_subpanel?
      params[:panel][:panel_number] or params[:panel][:panel_locaiton]
    end
end
