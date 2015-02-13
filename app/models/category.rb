class Category < ActiveRecord::Base
  
  has_many :videos, -> { order created_at: :desc }
  
  validates_presence_of :name
  
  # only return the most recent 6 videos for the category
  def recent_videos
    self.videos.first(6)
  end
  
end