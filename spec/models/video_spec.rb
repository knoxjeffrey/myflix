require 'spec_helper'
    
describe Video do
  
  it { should belong_to :category }
  it { should have_many(:reviews).order(created_at: :desc) }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  
  describe :search_by_title do
    let(:monk) { Video.create(title: "Monk", description: "Series about a detective", created_at: 1.day.ago) }
    
    it "should return an empty array if no title matches the search" do 
      expect(Video.search_by_title("South Park")).to eq([])
    end
    
    it "should return an array of one title if there is a match" do
      expect(Video.search_by_title("Monk")).to eq([monk])
    end
    
    it "should return an array of one title that matches a partial search term" do
      expect(Video.search_by_title("onk")).to eq([monk])
    end
    
    it "should return an array of matches ordered by created_at" do
      monk_detective = Video.create(title: "Monk Detective", description: "A Monk rip off")      
      expect(Video.search_by_title("mo")).to eq([monk_detective, monk])
    end
    
    it "should return an array of matches independent of case" do 
      monk_detective = Video.create(title: "Monk Detective", description: "A Monk rip off")
      expect(Video.search_by_title("mo")).to eq([monk_detective, monk])
    end 
    
    it "should return an empty array for an empty string search term" do
      expect(Video.search_by_title("")).to eq([])
    end 
    
  end
  
  describe :display_large_video_image do
    
    it "should display a large video image if one is available" do
      video2 = object_generator(:video_upload)
      expect(video2.display_large_video_image).to eq("https://knoxjeffrey-myflix-development.s3.amazonaws.com/uploads/monk_large.jpg")
    end
  
    it "should display a placeholder image if there is no large video image"  do
      video = object_generator(:video)
      expect(video.display_large_video_image ).to eq("http://dummyimage.com/665x375/000/fff.png&text=No+Preview+Available")
    end
    
    it "should display a placeholder image if large_cover_url is an empty string" do
      video = object_generator(:video)
      video.large_cover = ""
      expect(video.display_large_video_image ).to eq("http://dummyimage.com/665x375/000/fff.png&text=No+Preview+Available")
    end
    
    it "should display a placeholder image if the large_cover_url path does not exist" do
      video = object_generator(:video)
      video.large_cover = "/tmp/monk_large2.jpg"
      expect(video.display_large_video_image ).to eq("http://dummyimage.com/665x375/000/fff.png&text=No+Preview+Available")
    end
  
  end
  
  describe :average_rating do
    let(:video) { object_generator(:video) }
    it "returns a rating of zero if there are no reviews" do
      expect(video.average_rating).to eq(0)
    end
    
    it "should display the average score for a video" do
      object_generator(:review, rating: 5, video: video, user: object_generator(:user))
      object_generator(:review, rating: 1, video: video, user: object_generator(:user))
      object_generator(:review, rating: 1, video: video, user: object_generator(:user))
      
      expect(video.average_rating).to eq(2.3)
    end
  end

end