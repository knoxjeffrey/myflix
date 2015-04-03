class Video < ActiveRecord::Base
  
  belongs_to :category
  has_many :reviews, -> { order created_at: :desc }
  
  validates_presence_of :title, :description
  
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
  # Called on the class to search for a specific video title
  # Can find partial matches and is case insensitive due to ILIKE. Returns an array of matches or empty array if no matches
  # Order is by most recent created_at value first
  # example Video.search_by_title("mon")
  # => ["Monk", "Monkey"]
  def self.search_by_title(video_title)
    video_title.present? ? where("title ILIKE ?", "%#{video_title}%").order(created_at: :desc) : []
  end
  
end