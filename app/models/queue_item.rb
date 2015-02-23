class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  
  validates_numericality_of :list_position, { only_integer: true }
  
  # This means I don't need a category method to return video.category.
  # When QueueItem.category is called it automatically looks for video.category
  # Also, for category_name I don't need video.category.name because video.category is already delegated as category
  delegate :category, to: :video
  
  # This means I do not need a video_title method to return video.title
  # When QueueItem.video_title is called it automatically looks for video.title
  delegate :title, to: :video, prefix: :video
  
  def rating
    review.rating if review
  end
  
  def rating=(new_rating)
    if review && new_rating.blank?
      review.destroy
    elsif review
      Review.update(review.id, rating: new_rating)
    elsif new_rating.present?
      new_record = Review.new(user_id: user.id, video_id: video.id, rating: new_rating)
      new_record.save(validate: false)
    end
  end
  
  def category_name
    category.name
  end
  
  def self.update_list(data, index)
    update(data[:id], list_position: index+1, rating: data[:rating])
  end
  
  private
  
  def review
    @review_record ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end