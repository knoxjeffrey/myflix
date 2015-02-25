require 'spec_helper'

feature "user signs in" do

  given(:valid_user) { object_generator(:user) }
  
  scenario "with existing email and correct password" do
    sign_in_user(valid_user)
    expect(page.find('.dropdown #dlabel').text).to have_content valid_user.full_name
  end
  
  scenario "with incorrect login details" do
    visit sign_in_path
    fill_in "Email Address", with: valid_user.email_address
    fill_in "Password", with: "totally wrong password"
    click_button "Sign In"
    expect(current_path).to eq(sign_in_path)
    expect(page).to have_content "There is a problem with your username or password"
  end
end