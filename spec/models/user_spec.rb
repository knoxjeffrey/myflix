require 'spec_helper'

describe User do
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should have_many(:queue_items).order(list_position: :asc) }
  
  it { should validate_presence_of :email_address }
  it { should validate_presence_of :password }
  it { should validate_presence_of :full_name }
  
  it { should validate_uniqueness_of :email_address }
  
  it { should_not allow_value("test@test").for(:email_address) }
  it { should allow_value("test@test.com").for(:email_address) }
  
  it { should validate_length_of(:password).is_at_least(5) } 
  
  describe :queue_item_exists? do
    let(:user) { object_generator(:user) }
    let(:video) { object_generator(:video) }
    
    it "returns true if current user already has video in the queue" do
      object_generator(:queue_item, user: user, video: video)
      expect(user.queue_item_exists?(video)).to be true
    end
    
    it "returns false if current does not have video in the queue" do
      object_generator(:queue_item, video: video)
      expect(user.queue_item_exists?(video)).to be false
    end
  end
  
  describe :end_of_list do
    it "add 1 to the current count of queued items for the user" do
      user = object_generator(:user) 
      video = object_generator(:video)
      object_generator(:queue_item, user: user, video: video)
      
      expect(user.end_of_list).to eq(2)
    end
  end
  
  describe :owns_queued_item? do
    let(:user) { object_generator(:user) }
    let(:video) { object_generator(:video) }
    
    it "returns true if queued item belongs to the user" do
      queue_video = object_generator(:queue_item, user: user, video: video)
      
      expect(user.owns_queued_item?(queue_video)).to be true
    end
    
    it "returns false if the queued item does not belong to the user" do
      user1 = object_generator(:user) 
      queue_video = object_generator(:queue_item, user: user1, video: video)
      
      expect(user.owns_queued_item?(queue_video)).to be false
    end
  end
  
  describe :follows? do
    let(:user1) { object_generator(:user) }
    let(:user2) { object_generator(:user) }
    
    it "returns true if current user already follows the user" do
      object_generator(:friendship, user: user1, friend: user2)
      expect(user1.follows?(user2)).to be true
    end
    
    it "returns false if current user does not follow the user" do
      expect(user1.follows?(user2)).to be false
    end
  end
  
  describe :follow do
    let(:user1) { object_generator(:user) }
    let(:user2) { object_generator(:user) }
    
    it "follows another user" do
      user1.follow(user2)
      expect(user1.follows?(user2)).to be true
    end
    
    it "doesn't follow oneself" do
      user1.follow(user1)
      expect(user1.follows?(user1)).to be false
    end
    
  end
  
  describe :is_admin? do
    
    it "returns true if user is admin" do
      user = object_generator(:admin)
      expect(user.is_admin?).to be true
    end
    
    it "returns false if user is not admin" do
      user = object_generator(:user)
      expect(user.is_admin?).to be false
    end
  end
  
  describe :deactivate! do
    let(:user1) { object_generator(:user, active: true) }
    
    it "deactivates a user by setting active to false" do
      user1.deactivate!
      expect(user1).not_to be_active
    end
  end
end
