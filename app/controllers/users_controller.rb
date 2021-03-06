class UsersController < ApplicationController
  
  before_action :require_user, only: [:show]
  
  def new
    redirect_to home_path and return if logged_in?
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.valid?
      attempt_card_payment = subscription_payment_processor
      if attempt_card_payment.successful?
        @user.customer_token = attempt_card_payment.customer_token
        @user.save
        check_for_invitation
        send_email
        flash[:success] = "Thank you for registering, please sign in."
        redirect_to sign_in_path
      else
        handle_create_error(attempt_card_payment.error)
      end
    else
      handle_create_error("Please fix the errors in this form.")
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
      InvitationHandler.new(user: @user, invitation_token: params[:invitation_token]).handle_invitation
    end
  end

  def subscription_payment_processor
    ExternalPaymentProcessor.create_customer_subscription(
      email: @user.email_address,
      token: params[:stripeToken]
    )
  end
  
  def send_email
    AppMailer.delay.notify_on_user_signup(@user)
  end
  
  def handle_create_error(error)
    flash.now[:danger] = error
    render :new
  end

end