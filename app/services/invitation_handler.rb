class InvitationHandler
  
  def initialize(options={})
    @user = options[:user]
    @token = options[:invitation_token]
  end
  
  def handle_invitation
    invitation = Invitation.find_by(token: token)
    user.follow(invitation.inviter)
    invitation.inviter.follow(user)
    invitation.clear_token_column
  end
  
  private
  
  attr_reader :token, :user
  
end