class FriendshipsController < ApplicationController
  
  before_action :require_user
  
  def index
    @friendships = current_user.people_they_are_following
  end
  
  def destroy
    delete_selected_friendship
    redirect_to people_path
  end
  
  private
  
  def delete_selected_friendship
    friendship = Friendship.find_by_friend_id(params[:id])
    friendship.destroy if friendship.user == current_user
  end
  
end