class UsersController < ApplicationController
  
  before_action :require_user, only: [:show]
  
  def new
    redirect_to home_path and return if logged_in?
    @user = User.new
  end
  
  def create
    rollback = false
    @user = User.new(user_params)
    
    ActiveRecord::Base.transaction do
      if @user.save
        check_for_invitation
        
        if process_payment
          send_email
          redirect_to sign_in_path
        else
          rollback = true
          raise ActiveRecord::Rollback
        end
        
      else
        render :new
      end
    end
    redirect_to register_path if rollback
end 
  
  def show
    @user = User.find(params[:id])
  end
  
  def new_invitation_with_token
    invitation = Invitation.find_by_token(params[:token])
    if invitation
      @user = User.new(email_address: invitation.recipient_email_address)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email_address, :password, :full_name)
  end
  
  def check_for_invitation
    if params[:invitation_token].present?
      handle_invitation
    end
  end
  
  def handle_invitation
    invitation = Invitation.find_by_token(params[:invitation_token])
    @user.follow(invitation.inviter)
    invitation.inviter.follow(@user)
    invitation.clear_token_column
  end
  
  def process_payment
    begin
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      Stripe::Charge.create(
        amount: 999,
        currency: "gbp",
        source: params[:stripeToken],
        description: "Sign up charge for #{@user.email_address}"
      ) 
    rescue Stripe::CardError => e
      flash[:danger] = e.message
      return false
    end  
  end
  
  def send_email
    AppMailer.delay.notify_on_user_signup(@user)
  end
  
end