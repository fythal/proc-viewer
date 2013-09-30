# -*- coding: utf-8 -*-
class SearchesController < ApplicationController
  before_action :set_search, only: [:show]

  # GET /searches/1
  # GET /searches/1.json
  def show
    @anns = Ann.search(@search.keywords)
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)

    respond_to do |format|
      if @search.save
        format.html { redirect_to @search }
      else
        format.html { redirect_to :back }
      end
    end
  end

  private

  def search_params
    params.permit(search: [:keywords])[:search]
  end

  def set_search
    @search = Search.find(params[:id])
  end
end
