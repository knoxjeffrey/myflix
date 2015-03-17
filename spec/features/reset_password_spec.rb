require 'spec_helper'

feature "reset password" do

  scenario "user successfully resets password" do
    
    valid_user = object_generator(:user, email_address: 'knoxjeffrey@outlook.com', password: 'old_password')
    
    go_to_sign_in_path
    click_link "Forgot Password"
    
    expect_to_be_on_forgot_password_path
    fill_in_email_address(valid_user)
    
    click_button "Send Email"
    open_email('knoxjeffrey@outlook.com')
    click_reset_password_link
    
    expect_user_to_be_on_password_reset_page(valid_user)
    fill_in_password
    click_button "Reset Password"
    
    expect_user_to_be_on_sign_in_path
    fill_in_user_details(valid_user)
    click_button "Sign In"
    
    expect_to_be_on_home_path
    expect_page_to_have_user_full_name(valid_user)
    
    clear_emails
  end
  
  def go_to_sign_in_path
    visit sign_in_path
  end
  
  def expect_to_be_on_forgot_password_path
    expect(current_path).to eq(forgot_password_path)
  end
  
  def fill_in_email_address(user)
    fill_in :email_address, with: user.email_address
  end
  
  def click_reset_password_link
    current_email.click_link 'Reset My Password'
  end
  
  def expect_user_to_be_on_password_reset_page(user)
    expect(current_path).to eq("#{password_resets_path}/#{user.reload.token}")
  end
  
  def fill_in_password
    fill_in :password, with: new_password
  end
  
  def expect_user_to_be_on_sign_in_path
    expect(current_path).to eq(sign_in_path)
  end
  
  def fill_in_user_details(user)
    fill_in :email_address, with: user.email_address
    fill_in :password, with: new_password
  end
  
  def new_password
    'new_password'
  end
  
  def expect_to_be_on_home_path
    expect(current_path).to eq(home_path)
  end
  
  def expect_page_to_have_user_full_name(user)
    expect(page).to have_content("Welcome, #{user.full_name}")
  end
end