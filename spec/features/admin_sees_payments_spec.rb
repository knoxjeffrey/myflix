require 'spec_helper'

feature 'admin sees payments' do
  
  background do
    valid_user = object_generator(:user, full_name: "Jeff Knox", email_address: 'knoxjeffrey@outlook.com')
    object_generator(:payment, amount: 999, user: valid_user)
  end
  
  scenario "admin can see payments" do
    admin_user = object_generator(:admin)
    sign_in_user(admin_user)
    
    visit admin_payments_path
    
    expect(page).to have_content("£9.99")
    expect(page).to have_content("Jeff Knox")
    expect(page).to have_content("knoxjeffrey@outlook.com")
  end
  
  scenario "user cannot see payments" do
    sign_in_user(object_generator(:user))
    visit admin_payments_path
    
    expect(page).not_to have_content("£9.99")
    expect(page).not_to have_content("Jeff Knox")
    expect(page).not_to have_content("knoxjeffrey@outlook.com")
    expect(page).to have_content("You do not have access to that area.")
  end
  
end