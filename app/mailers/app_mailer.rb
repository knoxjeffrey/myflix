class AppMailer < ActionMailer::Base
  def notify_on_user_signup(user)
    @user = user
    mail from: 'info@tamars.co.uk', to: user.email_address, subject: "Welcome to MyFLiX"
  end
  
  def send_forgot_password(user)
    @user = user
    mail from: 'info@tamars.co.uk', to: user.email_address, subject: "Reset Password"
  end
end