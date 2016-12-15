class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_path
    else
      @session = nil
    end   
  end

  def create
    user = User.authenticate(params[:user_email], params[:user_password])
    if user
      session[:user_id] = user.id
      redirect_to garages_path
    else
      flash[:error] = "Invalid email or password"
      render 'new'
    end

    # Twilio api

    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:pre_2fa_auth_user_id] = @user.id

      #Try to verify with OneTouch
      one_touch = Authy::OneTouch.send_approval_request(
        id: @user.authy_id,
        message: "Request to Login to Twilio demo app",
        deatils: {
          'Email Address' => @user.email,
        }
      )
      status = one_touch['success'] ? :onetouch : :sms
      @user.update(authy_status: status)

      # Respond to the ajax call that requested this with approval request body
      render json: { success: one_touch['success'] }
    else
      @user ||= User.new(email: params[:email])
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to garages_path
  end
end
