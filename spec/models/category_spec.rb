require 'spec_helper'

describe Category do
  
  it { should have_many :videos }
  
  it { should validate_presence_of :name }
  
  describe :recent_videos do
    
    let!(:entertainment) { Category.create(name: "Entertainment") }
    let!(:futurama) { Video.create(title: "Futurama", description: "Accidentally frozen, pizza-deliverer", category: entertainment, created_at: 1.day.ago) }
    let!(:monk) { Video.create(title: "Monk", description: "Series about a detective", category: entertainment) }
    subject { entertainment.recent_videos }
    
    it "should return a list of videos from the category with the most recent first" do
      expect(subject).to eq([monk, futurama])
    end
    
    it "should return all videos if there are less than 6 videos in the category" do 
      futurama2 = Video.create(title: "Futurama", description: "Accidentally frozen, pizza-deliverer", category: entertainment, created_at: 3.days.ago)
      monk2 = Video.create(title: "Monk", description: "Series about a detective", category: entertainment)
      futurama3 = Video.create(title: "Futurama", description: "Accidentally frozen, pizza-deliverer", category: entertainment, created_at: 2.day.ago)
      expect(subject).to eq([monk2, monk, futurama, futurama3, futurama2])
    end
    
    it "should return the most recent 6 videos in the category if there are more than 6 videos" do
      futurama2 = Video.create(title: "Futurama", description: "Accidentally frozen, pizza-deliverer", category: entertainment, created_at: 3.days.ago)
      monk2 = Video.create(title: "Monk", description: "Series about a detective", category: entertainment)
      futurama3 = Video.create(title: "Futurama", description: "Accidentally frozen, pizza-deliverer", category: entertainment, created_at: 2.days.ago)
      futurama4 = Video.create(title: "Futurama", description: "Accidentally frozen, pizza-deliverer", category: entertainment, created_at: 4.days.ago)
      monk3 = Video.create(title: "Monk", description: "Series about a detective", category: entertainment)
      futurama5 = Video.create(title: "Futurama", description: "Accidentally frozen, pizza-deliverer", category: entertainment, created_at: 5.days.ago)
      monk4 = Video.create(title: "Monk", description: "Series about a detective", category: entertainment)
      futurama6 = Video.create(title: "Futurama", description: "Accidentally frozen, pizza-deliverer", category: entertainment, created_at: 6.days.ago)
      expect(subject).to eq([monk4, monk3, monk2, monk, futurama, futurama3])
    end
    
    it "should return an empty array if there are no videos in the category" do
      Video.destroy_all
      expect(subject).to eq([])
    end
  
  end
  
end