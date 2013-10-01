# -*- coding: utf-8 -*-
class LoginsController < ApplicationController
  before_action :set_user, only: [:create]

  skip_before_action :identify_user

  # GET /logins/new
  def new
    @login = Login.new
    @users = User.all.sort
  end

  # POST /logins
  def create
    @login = Login.new(user: @user)

    respond_to do |format|
      if @login.save
        session[:current_login_id] = @login.id

        if session[:search_keywords]
          (@search = Search.create(keywords: session[:search_keywords], user: @user)) && session[:search_keywords] = nil
        end

        format.html do
          if @search
            redirect_to @search, notice: "ようこそ、#{@user.name} さん"
          else
            flash[:notice] = "ようこそ、#{@user.name} さん"
            render action: 'show'
          end
        end
      else
        format.html { render action: 'new' }
      end
    end
  end

  private

  def login_params
    params.require(:login).permit(:user_id, :new_user_name)
  end

  def set_user
    new_name = login_params[:new_user_name]
    unless new_name.blank?
      @user = User.find_or_create_by(name: new_name)
    else
      @user = User.find(login_params[:user_id])
    end
  end
end
