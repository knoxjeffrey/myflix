class SessionsController < ApplicationController
  
  def new
    redirect_to home_path if logged_in?
  end
  
  def create
    user = User.find_by(email_address: params[:email_address])
    
    if user && user.authenticate(params[:password])
      if user.active?
        login_user!(user)
      else
        flash[:danger] = "Your account has been suspended, please contact customer services."
        redirect_to sign_in_path
      end
    else
      flash[:danger] = "There is a problem with your username or password"
      redirect_to sign_in_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:danger] = "You've logged out"
    redirect_to root_path 
  end
  
  private
  
  def login_user!(user)
    session[:user_id] = user.id #this is backed by the browsers cookie to track if the user is authenticated
    flash[:success] = "Welcome #{current_user.full_name}, you're logged in!"
    redirect_to home_path
  end
  
end