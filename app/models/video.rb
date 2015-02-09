class Video < ActiveRecord::Base
  
  belongs_to :category
  
  validates :title, presence: true
  validates :description, presence: true
  
  def display_large_video_image
    self.large_cover_url.present? ? self.large_cover_url : "http://dummyimage.com/665x375/000000/00a2ff"
  end
  
end