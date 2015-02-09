require 'spec_helper'
    
describe Video do
  
  it { should belong_to :category }
  
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  
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