require 'spec_helper'
    
describe Video do
  
  it { should belong_to :category }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  
  describe :search_by_title do
    it "should return an empty array if no title matches the search" do 
      monk = Video.create(title: "Monk", description: "Series about a detective")
      expect(Video.search_by_title("South Park")).to eq([])
    end
    
    it "should return an array of one title if there is a match" do
      monk = Video.create(title: "Monk", description: "Series about a detective")
      expect(Video.search_by_title("Monk")).to eq([monk])
    end
    
    it "should return an array of one title that matches a partial search term" do
      monk = Video.create(title: "Monk", description: "Series about a detective")
      expect(Video.search_by_title("onk")).to eq([monk])
    end
    
    it "should return an array of matches ordered by created_at" do
      monk = Video.create(title: "Monk", description: "Series about a detective", created_at: 1.day.ago)
      monk_detective = Video.create(title: "Monk Detective", description: "A Monk rip off")
      expect(Video.search_by_title("mo")).to eq([monk_detective, monk])
    end
    
    it "should return an array of matches independent of case" do 
      monk = Video.create(title: "Monk", description: "Series about a detective")
      monk_detective = Video.create(title: "Monk Detective", description: "A Monk rip off")
      expect(Video.search_by_title("mo")).to eq([monk_detective, monk])
    end 
    
    it "should return an empty array for an empty string search term" do
      monk = Video.create(title: "Monk", description: "Series about a detective")
      expect(Video.search_by_title("")).to eq([])
    end 
    
  end
  
  describe :display_large_video_image do
    
    it "should display a large video image if one is available" do
      video = Video.new(title: "Monk", description: "Series about a detective", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large.jpg")
      expect(video.display_large_video_image).to eq("/tmp/monk_large.jpg")
    end
  
    it "should display a placeholder image if there is no large video image"  do
      video = Video.new(title: "Monk", description: "Series about a detective", small_cover_url: "/tmp/monk.jpg")
      expect(video.display_large_video_image).to eq("http://dummyimage.com/665x375/000000/00a2ff")
    end
    
    it "should display a placeholder image if large_cover_url is an empty string" do
      video = Video.new(title: "Monk", description: "Series about a detective", small_cover_url: "/tmp/monk.jpg", large_cover_url: "")
      expect(video.display_large_video_image).to eq("http://dummyimage.com/665x375/000000/00a2ff")
    end
    
    it "should display a placeholder image if the large_cover_url path does not exist" do
      video = Video.new(title: "Monk", description: "Series about a detective", small_cover_url: "/tmp/monk.jpg", large_cover_url: "/tmp/monk_large2.jpg")
      expect(video.display_large_video_image).to eq("http://dummyimage.com/665x375/000000/00a2ff")
    end
  
  end

end