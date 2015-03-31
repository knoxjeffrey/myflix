require 'spec_helper'

feature "User registers", { js: true, vcr: true} do
  background do 
    page.driver.allow_url("js.stripe.com")
    page.driver.allow_url("api.stripe.com")
    visit register_path 
  end
  
  scenario "with valid personal and valid card info" do
    fill_in_valid_user_info
    fill_in_valid_card_info
    click_sign_up
    
    expect(page).to have_content("Thank you for registering, please sign in.")
  end
  
  scenario "with valid personal and invalid card info" do
    fill_in_valid_user_info
    fill_in_invalid_card_info
    click_sign_up
    
    expect(page).to have_content("This card number looks invalid.")
  end
  
  scenario "with valid personal and declined card" do
    fill_in_valid_user_info
    fill_in_declined_card
    click_sign_up
    
    expect(page).to have_content("Your card was declined.")
  end
  
  scenario "with invalid personal and valid card info" do
    fill_in_invalid_user_info
    fill_in_valid_card_info
    click_sign_up
    
    expect(page).to have_content("Please fix the errors in this form.")
  end
  
  scenario "with invalid personal and invalid card info" do
    fill_in_invalid_user_info
    fill_in_invalid_card_info
    click_sign_up
    
    expect(page).to have_content("This card number looks invalid.")
  end
  
  scenario "with invalid personal and declined card" do
    fill_in_invalid_user_info
    fill_in_declined_card
    click_sign_up
    
    expect(page).to have_content("Please fix the errors in this form.")
  end
  
  def fill_in_valid_user_info
    fill_in "Email Address", with: 'test@test.com'
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: "Test User"
  end
  
  def fill_in_invalid_user_info
    fill_in "Email Address", with: ''
    fill_in 'Password', with: 'password'
    fill_in 'Full Name', with: "Test User"
  end
  
  def fill_in_valid_card_info
    fill_in 'credit_card_number', with: '4242424242424242'
    fill_in 'credit_card_cvc', with: '123'
  end
  
  def fill_in_invalid_card_info
    fill_in 'credit_card_number', with: '123'
    fill_in 'credit_card_cvc', with: '123'
  end
  
  def fill_in_declined_card
    fill_in 'credit_card_number', with: '4000000000000002'
    fill_in 'credit_card_cvc', with: '123'
  end
  
  def click_sign_up
    click_button "Sign Up"
  end
end