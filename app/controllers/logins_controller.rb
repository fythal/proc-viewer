# -*- coding: utf-8 -*-
class LoginsController < ApplicationController

  skip_before_action :identify_user

  # GET /logins/new
  def new
    @login = Login.new
    @users = User.all.sort
  end
end
