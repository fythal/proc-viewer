class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :identify_user

  protected

  def identify_user
    unless loggin_correctly
      redirect_to new_login_url, notice: "Please log in"
    end
  end

  def loggin_correctly
    !session[:login].nil? and session[:login].kind_of?(Login) and session[:login].valid?
  end
end
