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
    normalize_queue_item_positions
    
    redirect_to my_queue_path
  end
  
  # sort the queue items by their list position
  def sort
    if !position_is_integer?
      flash[:danger] = "You can only enter integer numbers in the list order"
      redirect_to my_queue_path and return
    end
    
    normalize_queue_item_positions
   
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
  
  def check_position_for_non_integers
    if !position_is_integer?
      flash[:danger] = "You can only enter integer numbers in the list order"
      redirect_to my_queue_path and return
    end
  end
  
  # all? returns true if the block never returns false or nil
  # Integer('e') raises an exception so need the rescue
  def position_is_integer?
    params[:queue_array].all?{|data| Integer(data[:position]) rescue false }
  end
  
  def normalize_queue_item_positions
    if params[:action] == 'sort'
      order_by_postion_number.each_with_index do |data, index|
        update_list(data, index)
      end
    elsif params[:action] == 'destroy'
      current_user.queue_items.each_with_index do |queue_item, index|
        update_list(queue_item, index)
      end
    end
  end
  
  def order_by_postion_number
    params[:queue_array].sort_by{|data| data[:position] }
  end
  
  def update_list(data, index)
    QueueItem.update(data[:id], list_position: index+1) if QueueItem.find(data[:id]).user == current_user
  end
  
end