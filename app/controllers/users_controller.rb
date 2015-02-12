class UsersController < ApplicationController
  
  def new
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