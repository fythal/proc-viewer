class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :identify_user

  protected

  def identify_user
    unless current_user
      unless search_params.nil?
        session[:search_keywords] = search_params[:keywords]
      end
      redirect_to new_login_url, notice: "Please log in"
    end
  end

  def current_user
    begin
      @_current_user ||= session[:current_login_id] && Login.find_by_id(session[:current_login_id]).user
    rescue NoMethodError
      nil
    end
  end
end
