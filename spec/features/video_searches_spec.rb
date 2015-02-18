require 'spec_helper'

feature "video searches" do
  
  background do
    object_generator(:video, title: "Godfather")
    sign_in_user
  end
  
  scenario "user searches for video that isn't present" do
    fill_in :video_title, with: "Splash"
    click_button "Search"
    expect(current_path).to eq(search_videos_path)
    expect(page).to have_content /no results/i
    #save_and_open_page
  end
  
  scenario "user searches for video with exact title" do
    fill_in :video_title, with: "Godfather"
    click_button "Search"
    expect(current_path).to eq(search_videos_path)
    expect(page).to have_selector(".video")
  end
  
  scenario "user searches for video with partial title" do
    fill_in :video_title, with: "father"
    click_button "Search"
    expect(current_path).to eq(search_videos_path)
    expect(page).to have_selector(".video")
  end
  
end