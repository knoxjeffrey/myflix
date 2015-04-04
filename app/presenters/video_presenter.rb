class VideoPresenter
  def initialize(video)
    @video = video
  end
  
  # If large_cover is present then return image url,  otherwise disply dummy image
  def display_large_video_image
    video.large_cover.present? ? video.large_cover_url : "http://dummyimage.com/665x375/000/fff.png&text=No+Preview+Available"
  end
  
  # calulate average rating for video to 1 decimal point
  def average_rating
    video.reviews.present? ? "#{video.reviews.average(:rating).round(1)}/5" : 'N/A'
  end
  
  private
  
  attr_reader :video
end