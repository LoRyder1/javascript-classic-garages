class UsersController < ApplicationController
  def home
    
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id

      authy = Authy::API.register_user(
        email: @user.email, 
        cellphone: @user.phone_number, 
        country_code: @user.country_code
        )
      @user.update(authy_id: authy.id)
      
      redirect_to garages_path
    else
      render 'new'
    end
  end

  def doc
  end

  private

  def user_params
    params.require(:user).permit(
      :username, :email, :password, :password_confirmation, :country_code, :phone_number
    )
  end

  def redirect_if_logged_in
    redirect_to root_path if logged_in?
  end
end
