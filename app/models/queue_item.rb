class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  
  # This means I don't need a category method to return video.category.
  # When QueueItem.category is called it automatically looks for video.category
  # Also, for category_name I don't need video.category.name because video.category is already delegated as category
  delegate :category, to: :video
  
  # This means I do not need a video_title method to return video.title
  # When QueueItem.video_title is called it automatically looks for video.title
  delegate :title, to: :video, prefix: :video
  
  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end
  
  def category_name
    category.name
  end
end