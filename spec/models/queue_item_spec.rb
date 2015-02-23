require 'spec_helper'

describe QueueItem do
  it { should belong_to :user }
  it { should belong_to :video }
  it { should validate_numericality_of(:list_position).only_integer }
  
  describe :video_title do
    it "returns the title of the associated video" do
      video1 = object_generator(:video)
      queue_item1 = object_generator(:queue_item, video: video1)
      expect(queue_item1.video_title).to eq(video1.title)
    end
  end
  
  describe :rating do
    context "when review present" do
      it "returns the rating of the video" do
        video1 = object_generator(:video)
        user1 = object_generator(:user)
        review1 = object_generator(:review, video: video1, rating: 5, user: user1)
        queue_item1 = object_generator(:queue_item, video: video1, user: user1)
        
        expect(queue_item1.rating).to eq(5)
      end
    end
    
    context "when no review" do
      it "returns nil" do
        video1 = object_generator(:video)
        user1 = object_generator(:user)
        queue_item1 = object_generator(:queue_item, video: video1, user: user1)
        
        expect(queue_item1.rating).to eq(nil)
      end
    end
  end
  
  describe :rating= do
    let(:video1) { object_generator(:video) }
    let(:user1) { object_generator(:user) }
    
    context "when review present" do

      it "changes the rating of the video" do
        review1 = object_generator(:review, video: video1, rating: 5, user: user1)
        queue_item1 = object_generator(:queue_item, video: video1, user: user1)
        queue_item1.rating = 4
        
        expect(Review.first.rating).to eq(4)
      end 
      
      it "destroys the review if rating is changed to blank" do
        review1 = object_generator(:review, video: video1, rating: 5, user: user1)
        queue_item1 = object_generator(:queue_item, video: video1, user: user1)
        queue_item1.rating = ''
        
        expect(Review.where(video: video1, user: user1)).not_to exist
      end 
    end
    
    context "when no review" do
      
      it "creates a new rating for the video" do
        queue_item1 = object_generator(:queue_item, video: video1, user: user1)
        queue_item1.rating = 4
        
        expect(Review.first.rating).to eq(4)
      end
    end
  end
  
  describe :category_name do
    it "returns the category name of the associated video" do
      category1 = object_generator(:category)
      video1 = object_generator(:video, category: category1)
      queue_item1 = object_generator(:queue_item, video: video1)
      
      expect(queue_item1.category_name).to eq(video1.category.name)
    end
  end
  
  describe :category do
    it "returns the category of the associated video" do
      category1 = object_generator(:category)
      video1 = object_generator(:video, category: category1)
      queue_item1 = object_generator(:queue_item, video: video1)
      
      expect(queue_item1.category).to eq(category1)
    end
  end
end