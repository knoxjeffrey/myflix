# only for features. Creates a user and signs them in so they are on the home path
module FeatureSessionHelper
  
  def sign_in_user(a_user=nil)
    a_user ||= object_generator(:user)
    visit sign_in_path
    fill_in :email_address, with: a_user.email_address
    fill_in :password, with: a_user.password
    click_button "Sign In"
    expect(current_path).to eq(home_path)
  end
  
  def go_to_video_page(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
  end
  
  def sign_out
    visit sign_out_path
  end
  
end