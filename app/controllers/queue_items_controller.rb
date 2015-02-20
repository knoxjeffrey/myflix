class QueueItemsController < ApplicationController
  before_action :require_user
  
  def index
    @queue_items = current_user.queue_items
  end
  
  def create
    video = Video.find(params[:video_id])
    queue_the_item(video)
    redirect_to my_queue_path
  end
  
  def destroy
    queued_item = QueueItem.find(params[:id])
    queued_item.destroy if belongs_to_current_user?(queued_item)
 
    redirect_to my_queue_path
  end
  
  private
  
  def queue_the_item(item)
    if queue_item_exists?(item)
      flash[:danger] = "#{item.title} is already in your queue"
    else
      QueueItem.create(video_id: item.id, user_id: current_user.id, list_position: end_of_list)
    end
  end
  
  def queue_item_exists?(item)
    QueueItem.exists?(video_id: item, user_id: current_user.id)
  end
  
  def end_of_list
    current_user.queue_items.count + 1
  end
  
  def belongs_to_current_user?(item)
    item.user_id == current_user.id
  end
end