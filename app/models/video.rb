class Video < ActiveRecord::Base
  
  belongs_to :category
  
  validates_presence_of :title, :description
  
  #if large_cover_url has a non empty string and the file name exists then show the image
  #else show a placeholder image
  def display_large_video_image
    if self.large_cover_url.present?
      File.exists?(Rails.root.join("public" + self.large_cover_url)) ? self.large_cover_url : "http://dummyimage.com/665x375/000000/00a2ff"
    else  
      "http://dummyimage.com/665x375/000000/00a2ff"
    end
  end
  
end