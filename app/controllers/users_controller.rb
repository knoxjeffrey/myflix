class UsersController < ApplicationController
  
  before_action :require_user, only: [:show]
  
  def new
    redirect_to home_path and return if logged_in?
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.valid?
      check_for_invitation
      attempt_card_payment = payment_processor
      if attempt_card_payment.processed
        @user.save
        send_email
        flash[:success] = "Thank you for registering, please sign in."
        redirect_to sign_in_path
      else
        flash[:danger] = attempt_card_payment.error
        redirect_to register_path
      end
    else
      flash[:danger] = "Please fix the errors in this form."
      render :new
    end
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

  def payment_processor
    ExternalPaymentProcessor.charge({
      amount: 999,
      email: @user.email_address,
      token: params[:stripeToken]
    })
  end
  
  def send_email
    AppMailer.delay.notify_on_user_signup(@user)
  end

end