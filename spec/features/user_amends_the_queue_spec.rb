require 'spec_helper'

feature "user amends the queue" do
    
  scenario "user adds videos to the queue and then reorders them" do
    valid_user = object_generator(:user)
    entertainment = object_generator(:category)
    futurama = object_generator(:video, category: entertainment)
    monk = object_generator(:video, category: entertainment) 
    south_park = object_generator(:video, category: entertainment) 
    
    sign_in_user(valid_user)
    
    add_video_to_queue(futurama)
    expect_to_be_on_my_queue_page
    expect_video_to_be_in_queue(futurama)
    
    visit video_path(futurama)
    expect_link_not_to_be_seen("+ My Queue")
    
    add_video_to_queue(monk)
    
    add_video_to_queue(south_park)
    
    set_video_position(futurama, 3)
    set_video_position(monk, 1)
    set_video_position(south_park, 2)
    
    update_queue
    
    expect_video_position(monk, 1)
    expect_video_position(south_park, 2)
    expect_video_position(futurama, 3)

  end
  
  def expect_to_be_on_my_queue_page
    expect(current_path).to eq(my_queue_path)
  end
  
  def expect_video_to_be_in_queue(video)
    expect(page).to have_content video.title
  end
  
  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_content link_text
  end
  
  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end
  
  def update_queue
    click_button "Update Instant Queue"
  end
  
  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_array[][position]", with: position
    end
  end
  
  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end

end