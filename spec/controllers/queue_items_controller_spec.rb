require 'spec_helper'

describe QueueItemsController do
  
  describe "GET index" do
    context "with authenticated user" do
      let(:valid_user) { object_generator(:user) }
      let(:queued_item1) { object_generator(:queue_item, user: valid_user) }
      let(:queued_item2) { object_generator(:queue_item, user: valid_user) }
      
      before do
        session[:user_id] = valid_user.id
      end 
      
      it "assigns @queue_videos" do
        get :index
        expect(assigns(:queue_items)).to match_array([queued_item1,queued_item2])
      end
    end
    
    context "with unauthenticated user" do
      it "redirects to the root path" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
  
end
  