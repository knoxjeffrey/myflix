require 'spec_helper'

feature "social networking" do
  
  given(:user1) { object_generator(:user) }
  given(:entertainment) { object_generator(:category) }
  given(:futurama) { object_generator(:video, category: entertainment) }
    
  scenario "user follows another user and then unfollows" do

    user_to_follow = object_generator(:user)
    review = object_generator(:review, video: futurama, user: user_to_follow)
    
    sign_in_user(user1)
    go_to_video_page(futurama)
    
    click_on_user(user_to_follow)
    expect_to_be_on_user_page(user_to_follow)
    
    follow_user(user_to_follow)
    expect_to_be_on_people_path
    expect_user_to_be_in_people_i_follow(user_to_follow)
    
    unfollow_user(user_to_follow)
    expect_user_not_to_be_in_people_i_follow(user_to_follow)
  end
  
  scenario "user cannot follow themselves" do
    
    review = object_generator(:review, video: futurama, user: user1)
    
    sign_in_user(user1)
    go_to_video_page(futurama)
    
    click_on_user(user1)
    expect_to_be_on_user_page(user1)
    
    expect_not_to_see_follow_link
  end
  
  scenario "user cannot follow another user they are already following" do

    user_to_follow = object_generator(:user)    
    review = object_generator(:review, video: futurama, user: user_to_follow)    
    object_generator(:friendship, user: user1, friend: user_to_follow)
    
    sign_in_user(user1)
    go_to_video_page(futurama)
    
    click_on_user(user_to_follow)
    expect_to_be_on_user_page(user_to_follow)
    
    expect_not_to_see_follow_link
  end
  
  def click_on_user(user)
    find("a[href='/users/#{user.id}']").click
  end
  
  def expect_to_be_on_user_page(user)
    expect(current_path).to eq(user_path(user.id))
  end
  
  def follow_user(user)
    click_link "Follow"
  end
  
  def expect_to_be_on_people_path
    expect(current_path).to eq(people_path)
  end
  
  def expect_user_to_be_in_people_i_follow(user)
    expect(page).to have_content user.full_name
  end
  
  def unfollow_user(user)
    find("a[data-method='delete']").click
  end
  
  def expect_user_not_to_be_in_people_i_follow(user)
    expect(page).not_to have_content user.full_name
  end
  
  def expect_not_to_see_follow_link
    expect(page).not_to have_selector(:link_or_button, 'Follow')
  end
end