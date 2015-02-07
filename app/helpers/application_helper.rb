module ApplicationHelper
  def large_image_present?(video)
    video.large_cover_url.present? ? video.large_cover_url : "http://dummyimage.com/665x375/000000/00a2ff"
  end
end
