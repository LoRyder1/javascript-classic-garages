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
end