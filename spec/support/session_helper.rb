# only for features. Creates a user and signs them in so they are on the home path
module SessionHelper
  
  def sign_in_user(user=nil)
    user ||= object_generator(:user)
    visit sign_in_path
    fill_in :email_address, with: user.email_address
    fill_in :password, with: user.password
    click_button "Sign In"
    expect(current_path).to eq(home_path)
  end
  
end