class AuthyController < ApplicationController
  # before we allow the incoming request to callback, verify
  # that it is an Authy request
  before_filter :authenticate_authy_request, :only => [:callback]

  protect_from_forgery except: [:callback, :send_token]

  # The webhook setup for our Authy application this is where
  # the response from a OneTouch request will come

  def callback
    auth_id = params[:authy_id]
    begin
      @user = User.find_by! authy_id: authy_id
      @user.update(authy_status: params[:status])
    rescue => e
      puts e.message
    end
    render plain: 'OK'
  end

  def verify
    @user = User.find(session[:pre_2fa_auth_user_id])
    token = Authy::API.verify(:id @user.authy_id, token: params[:token])
    if token.ok?
      session[:user_id] = @user.id
      session[:pre_2fa_auth_user_id] = nil
      redirect_to account_path
    else
      flash.now[:danger] = "Incorrect code, please try again"
      redirect_to new_session_path
    end
  end
end