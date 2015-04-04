require 'spec_helper'

describe VideoPresenter do
  
  describe :display_large_video_image do
    
    it "displays a large video image if one is available" do
      video2 = object_generator(:video_upload)
      expect(VideoPresenter.new(video2).display_large_video_image).to eq("https://knoxjeffrey-myflix-development.s3-eu-west-1.amazonaws.com/uploads/monk_large.jpg")
    end
  
    it "displays a placeholder image if there is no large video image"  do
      video = object_generator(:video)
      expect(VideoPresenter.new(video).display_large_video_image ).to eq("http://dummyimage.com/665x375/000/fff.png&text=No+Preview+Available")
    end
  
  end
  
  describe :average_rating do
    let(:video) { object_generator(:video) }
    it "returns a rating of zero if there are no reviews" do
      expect(VideoPresenter.new(video).average_rating).to eq('N/A')
    end
    
    it "displays the average score for a video" do
      object_generator(:review, rating: 5, video: video, user: object_generator(:user))
      object_generator(:review, rating: 1, video: video, user: object_generator(:user))
      object_generator(:review, rating: 1, video: video, user: object_generator(:user))
      
      expect(VideoPresenter.new(video).average_rating).to eq('2.3/5')
    end
  end
  
end