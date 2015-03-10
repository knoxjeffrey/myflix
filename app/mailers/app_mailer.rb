class AppMailer < ActionMailer::Base
  def notify_on_user_signup(user)
    @user = user
    mail from: 'knoxjeffrey@outlook.com', to: user.email_address, subject: "Welcome to MyFLiX"
  end
end