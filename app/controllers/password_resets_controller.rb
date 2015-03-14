class PasswordResetsController < ApplicationController
  
  def show
    user = User.where(token: params[:id]).first
    
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end
  
  def expired_token; end
  
  def create
    user = User.where(token: params[:token]).first
    if user
      user.password = params[:password]
      
      if user.save
        user.remove_token!
        flash[:success] = "Your password has been changed, please sign in"
        redirect_to sign_in_path
      else
        @user = user
        @token = params[:token]
        render :show
      end
    else
      redirect_to expired_token_path
    end
  end
  
end