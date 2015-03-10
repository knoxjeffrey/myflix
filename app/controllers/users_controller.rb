class UsersController < ApplicationController
  
  before_action :require_user, only: [:show]
  
  def new
    redirect_to home_path and return if logged_in?
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      AppMailer.notify_on_user_signup(@user).deliver
      redirect_to sign_in_path
    else
      render :new
    end
  end 
  
  def show
    @user = User.find(params[:id])
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email_address, :password, :full_name)
  end
  
end