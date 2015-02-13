class UsersController < ApplicationController
  
  def new
    redirect_to home_path and return if logged_in?
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    @user.save ? (redirect_to sign_in_path) : (render :new)
  end 
  
  private
  
  def user_params
    params.require(:user).permit(:email_address, :password, :full_name)
  end
  
end