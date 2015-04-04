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

end