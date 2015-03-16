class InvitationsController < ApplicationController
  before_action :require_user
  
  def new
    @invitation = Invitation.new
  end
  
  def create
    @invitation = Invitation.new((invitation_params).merge!(inviter_id: current_user.id))
    if @invitation.save
      AppMailer.send_invite(@invitation).deliver
      flash[:success] = "You have successfully sent an invitaton to #{@invitation.recipient_email_address}"
      redirect_to invite_friend_path
    else
      render :new
    end
  end
  
  private
  
  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email_address, :message)
  end
  
end