class AppMailer < ActionMailer::Base
  def notify_on_user_signup(user)
    @user = user
    mail from: 'knoxjeffrey@outlook.com', to: user.email_address, subject: "Welcome to MyFLiX"
  end
  
  def send_forgot_password(user)
    @user = user
    mail from: 'knoxjeffrey@outlook.com', to: user.email_address, subject: "Reset Password"
  end
  
  def send_invite(invitation)
    @invitation = invitation
    mail from: invitation.inviter.email_address, to: invitation.recipient_email_address, subject: "Invitation from #{invitation.inviter.full_name} to join MyFLiX"
  end
end
