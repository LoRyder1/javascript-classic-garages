class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?, :signed_in?

  def current_user
    @user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !(session[:user_id].nil?)
  end

  def signed_in?
    current_user.present?
  end

  protected

  def authenticate!
    redirect_to new_session_path and return unless signed_in?
  end
end
