class Video < ActiveRecord::Base
  
  belongs_to :category
  has_many :reviews, -> { order created_at: :desc }
  
  validates_presence_of :title, :description
  
  # Called on the class to search for a specific video title
  # Can find partial matches and is case insensitive due to ILIKE. Returns an array of matches or empty array if no matches
  # Order is by most recent created_at value first
  # example Video.search_by_title("mon")
  # => ["Monk", "Monkey"]
  def self.search_by_title(video_title)
    video_title.present? ? where("title ILIKE ?", "%#{video_title}%").order(created_at: :desc) : []
  end
  
  # If large_cover_url has a non empty string and the file name exists then show the image
  # else show a placeholder image
  def display_large_video_image
    if self.large_cover_url.present?
      File.exists?(Rails.root.join("public" + self.large_cover_url)) ? self.large_cover_url : "http://dummyimage.com/665x375/000/fff.png&text=No+Preview+Available"
    else  
      "http://dummyimage.com/665x375/000/fff.png&text=No+Preview+Available"
    end
  end
  
  # calulate average rating for video to 1 decimal point
  def average_rating
    self.reviews.average(:rating) ? reviews.average(:rating).round(1) : 0
  end
  
end