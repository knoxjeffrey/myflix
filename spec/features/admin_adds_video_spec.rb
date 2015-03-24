require 'spec_helper'

feature 'admin adds video' do
  
  scenario "admin successfully adds a new video" do
    
    admin_user = object_generator(:admin)
    
    sign_in_user(admin_user)
    upload_video
    
    sign_out
    sign_in_user
    
    validate_uploaded_video
    
  end
  
  def upload_video
    category1 = object_generator(:category)
    
    click_link "Add Video"
    
    fill_in 'title_of_video', with: 'Monk'
    select category1.name, from: 'Category'
    fill_in 'Description', with: 'TV Drama'
    attach_file "Large Cover", "spec/support/uploads/monk_large.jpg"
    attach_file "Small Cover", "spec/support/uploads/monk.jpg"
    fill_in "Video URL", with: "http://www.test.com"
    click_button "Add Video"
  end
  
  def validate_uploaded_video
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='https://knoxjeffrey-myflix-development.s3.amazonaws.com/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://www.test.com']")
  end
end