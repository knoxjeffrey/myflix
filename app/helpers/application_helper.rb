module ApplicationHelper
  
  # method to create a customized form_for using my HorizontalFormBuilder class
  def horizontal_form_for(record, options = {}, &block)
    form_for(record, options.merge!({builder: HorizontalFormBuilder}), &block)
  end

  def vertical_form_for(record, options = {}, &block)
    form_for(record, options.merge!({builder: VerticalFormBuilder}), &block)
  end
  
  def star_rating
    [5,4,3,2,1].map { |rating| [pluralize(rating, 'Star'), rating]}
  end
  
  def link_to_my_queue(object)
    unless current_user.queue_item_exists?(object.id)
      link_to "+ My Queue", queue_items_path(video_id: object.id), method: :post, class: "btn btn-default" 
    end
  end

end
