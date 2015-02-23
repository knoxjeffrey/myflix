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
    queued_item.destroy if current_user.owns_item?(queued_item)
    normalize_queue_item_positions
    
    redirect_to my_queue_path
  end
  
  # sort the queue items by their list position
  def sort
    redirect_to my_queue_path and return if invalid_inputs?
    
    normalize_queue_item_positions
   
    redirect_to my_queue_path
  end
  
  private
  
  def queue_the_item(item)
    if current_user.queue_item_exists?(item)
      flash[:danger] = "#{item.title} is already in your queue"
    else
      QueueItem.create(video_id: item.id, user_id: current_user.id, list_position: current_user.end_of_list)
    end
  end

  def invalid_inputs?
    if !position_is_integer?
      flash[:danger] = "You can only enter integer numbers in the list order"
      true
    end
  end
  
  # all? returns true if the block never returns false or nil
  # Integer('e') raises an exception so need the rescue
  def position_is_integer?
    params[:queue_array].all?{|data| Integer(data[:position]) rescue false }
  end
  
  def normalize_queue_item_positions
    order_by_postion_number.each_with_index do |data, index|
      QueueItem.update_list(data, index) if QueueItem.find(data[:id]).user == current_user
    end
  end
  
  # the user can change the order of the list position number so they may now be out of order
  # this invokes the sort method which will sort the list by the list position numbers the user has entered and return an array
  # with a delete action there is no :queue_array in the params so the queue items of the current user is returned instead
  def order_by_postion_number
    if params.has_key?(:queue_array)
      params[:queue_array].sort_by{ |data| data[:position] }
    else
      current_user.queue_items
    end
  end
    
end