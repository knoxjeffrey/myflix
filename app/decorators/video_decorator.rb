class VideoDecorator < Draper::Decorator
  delegate_all
  
  # If large_cover is present then return image url,  otherwise disply dummy image
  def display_large_video_image
    object.large_cover.present? ? object.large_cover_url : "http://dummyimage.com/665x375/000/fff.png&text=No+Preview+Available"
  end
  
  # calulate average rating for video to 1 decimal point
  def average_rating
    object.reviews.present? ? "#{reviews.average(:rating).round(1)}/5" : 'N/A'
  end
end