class FriendshipsController < ApplicationController
  
  before_action :require_user
  
  def index
    @friendships = current_user.people_they_are_following
  end
  
  def create
    #binding.pry
    new_friend = User.find(params[:friend_id])
    add_as_friend(new_friend)
    
    redirect_to people_path
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
  
  def add_as_friend(add_friend)
    if current_user.friendships.exists?(friend: add_friend)
      flash[:danger] = "You are already following #{add_friend.full_name}"
    else
      Friendship.create(user: current_user, friend: add_friend)
    end
  end
  
end