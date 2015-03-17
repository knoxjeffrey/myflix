require 'spec_helper'

feature "user invites friend" do
  scenario "user successfully invites friend and is accepted" do
    inviter = object_generator(:user)
    
    sign_in_user(inviter)
    invite_friend
    
    open_email(friend_email)
    click_accept_invitation
    
    friend_signs_up
    expect_to_be_on_sign_in_path
    friend_signs_in
    
    expect_friend_to_follow(inviter)
    expect_inviter_to_follow_friend(inviter)

    clear_emails
  end
  
  def invite_friend
    click_link "Invite A Friend"
    
    fill_in "Friend's Name", with: friend_name
    fill_in "Friend's Email Address", with: friend_email
    fill_in "Invitation Message", with: "Come join MyFLiX"
    click_button "Send Invitation"
    sign_out
  end

  def friend_email
    'friend@test.com'
  end
  
  def friend_name
    'My Friend'
  end
  
  def friend_password
    'password'
  end
  
  def click_accept_invitation
    current_email.click_link "Accept Invitation"
  end
  
  def friend_signs_up
    fill_in_password
    fill_in 'Full Name', with: friend_name
    click_button "Sign Up"
  end
  
  def friend_signs_in
    fill_in "Email Address", with: friend_email
    fill_in_password
    click_button "Sign In"
  end
  
  def fill_in_password
    fill_in 'Password', with: friend_password
  end
  
  def expect_to_be_on_sign_in_path
    expect(current_path).to eq(sign_in_path)
  end
  
  def expect_friend_to_follow(inviter)
    click_link "People"
    expect(page).to have_content(inviter.full_name)
    sign_out
  end
  
  def expect_inviter_to_follow_friend(inviter)
    sign_in_user(inviter)
    click_link "People"
    expect(page).to have_content(friend_name)
  end

end