class ForgotPasswordsController < ApplicationController
  
  def new; end
  
  def create
    user = User.where(email_address: params[:email_address]).first
    
    if user
      user.generate_token
      #binding.pry
      AppMailer.send_forgot_password(user).deliver
      redirect_to forgot_password_confirmation_path
    else
      if params[:email_address].blank?
        flash[:danger] = "Email cannot be blank. Please try again."
      else
        flash[:danger] = "There is no user with that email in the system"
      end
      
      redirect_to forgot_password_path
    end
  end
  
  def confirm; end
  
end
