require 'spec_helper'

describe QueueItemsController do
  
  describe "GET index" do
    context "with authenticated user" do
      let(:valid_user) { object_generator(:user) }
      let(:queued_item1) { object_generator(:queue_item, list_position: 2, user: valid_user) }
      let(:queued_item2) { object_generator(:queue_item, list_position: 1, user: valid_user) }
      
      before do
        session[:user_id] = valid_user.id
      end 
      
      it "assigns @queue_videos" do
        get :index
        expect(assigns(:queue_items)).to match_array([queued_item1,queued_item2])
      end
      
      it "sorts the list by ascending list_position" do
        get :index
        expect(assigns(:queue_items)).to eq([queued_item2, queued_item1])
      end
    end
    
    context "with unauthenticated user" do
      it "redirects to the root path" do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "POST create" do
    context "with authenticated user" do
      let(:valid_user) { object_generator(:user) }
      let(:new_video) { object_generator(:video) }
      
      context "when the item is not already in the list" do
        before do
          session[:user_id] = valid_user.id
        end
        
        it "creates a new queue item" do
          post :create, video_id: new_video.id
          expect(QueueItem.count).to eq(1)
        end
        
        it "creates a new queue item with the associated video" do
          post :create, video_id: new_video.id
          expect(QueueItem.first.video).to eq(new_video)
        end
        
        it "creates a new queue item with the assocaited user" do
          post :create, video_id: new_video.id, user_id: valid_user.id
          expect(QueueItem.first.user).to eq(valid_user)
        end
       
        it "redirects to the my_queue page" do
          post :create, video_id: new_video.id, user_id: valid_user.id
          expect(response).to redirect_to my_queue_path
        end
        
        it "puts the queued item last in the list of queued items" do
          exisiting_video = object_generator(:video)
          object_generator(:queue_item, video: exisiting_video, user: valid_user)
          
          post :create, video_id: new_video.id, user_id: valid_user.id
          find_new_video = QueueItem.where(video_id: new_video.id, user_id: valid_user.id).first
          expect(find_new_video.list_position).to eq(2)
        end
      end
      
      context "when the item is already in the list" do
        before do
          session[:user_id] = valid_user.id
          object_generator(:queue_item, video: new_video, user: valid_user)
          post :create, video_id: new_video.id, user_id: valid_user.id
        end
        
        it "should not create a new queue item" do
          expect(valid_user.queue_items.count).to eq(1)
        end
        
        it "should display a message to inform the user that the item is already in the list" do
          expect(flash[:danger]).to be_present
        end
      end
    end
  
    context "with unauthenticated user" do
      it "redirects to the root page" do
        post :create, video_id: 1
        expect(response).to redirect_to root_path
      end
    end
    
  end
  
  describe "DELETE destroy" do
    context "with authenticated user" do
      
      context "with queued list associated with authenticated user" do
        let(:valid_user) { object_generator(:user) }
        let(:new_video) { object_generator(:video) }
        let(:queue_item) { object_generator(:queue_item, video: new_video, user: valid_user) }
        
        before do
          session[:user_id] = valid_user.id
        end
        
        it "should remove the item from the list of queued items" do
          delete :destroy, id: queue_item.id
          expect(valid_user.queue_items.count).to eq(0)
        end
      
        it "should redirect to my_queue page" do
          delete :destroy, id: queue_item.id
          expect(response).to redirect_to my_queue_path
        end
        
        it "normalizes the queue items" do
          queue_item2 = object_generator(:queue_item, user: valid_user, list_position: 2)
          delete :destroy, id: queue_item.id
          expect(QueueItem.first.list_position).to eq(1)
        end
      end
      
      context "with queued list not associated with authenticated user" do
        let(:valid_user) { object_generator(:user) }
        let(:other_user) { object_generator(:user) }
        let(:new_video) { object_generator(:video) }
        
        before do
          non_user_queue_item = object_generator(:queue_item, video: new_video, user: other_user)
          session[:user_id] = valid_user.id
          delete :destroy, id: non_user_queue_item.id
        end
        
        it "should not remove the item from the list of queued items" do
           expect(other_user.queue_items.count).to eq(1)
        end
      end
    end
    
    context "with unauthenticated user" do
      it "redirects to the root page" do
        delete :destroy, id: 1
        expect(response).to redirect_to root_path
      end
    end
  end
  
  describe "POST sort" do
    context "with authenticated user" do
      let(:valid_user) { object_generator(:user) }
      let(:new_video1) { object_generator(:video) }
      let(:new_video2) { object_generator(:video) }
      let(:queue_item1) { object_generator(:queue_item, video: new_video1, user: valid_user, list_position: 1) }
      let(:queue_item2) { object_generator(:queue_item, video: new_video2, user: valid_user, list_position: 2) }
      
      before do
        session[:user_id] = valid_user.id
      end
      
      context "with valid input" do
        
        it "redirects to my_queue page" do
          post :sort, queue_array: [{position: 2, id: queue_item1.id}, {position: 1, id: queue_item2.id}]
          expect(response).to redirect_to my_queue_path
        end
        
        it "sorts the queue items" do
          post :sort, queue_array: [{position: 2, id: queue_item1.id}, {position: 1, id: queue_item2.id}]
          expect(valid_user.queue_items).to eq [queue_item2, queue_item1]
        end
         
        it "normalizes the queue items" do
          post :sort, queue_array: [{position: 5, id: queue_item1.id}, {position: 3, id: queue_item2.id}]
          expect(valid_user.queue_items.map(&:list_position)).to eq [1,2]
        end
        
        it "does not alter another users queue items" do
          another_user = object_generator(:user)
          session[:user_id] = another_user.id
          
          post :sort, queue_array: [{position: 2, id: queue_item1.id}, {position: 1, id: queue_item2.id}]
          expect(valid_user.queue_items).to eq [queue_item1, queue_item2]
        end
        
      end
      
      context "with invalid input" do
        before do
          post :sort, queue_array: [{position: 'e', id: queue_item1.id}, {position: 2, id: queue_item2.id}]
        end
        
        it "redirects to my_queue page" do
          expect(response).to redirect_to my_queue_path
        end
        
        it "does not alter the users queue items" do
          expect(valid_user.queue_items).to eq [queue_item1, queue_item2]
        end
        
        it "should display a message to inform the user to only enter integers" do
          expect(flash[:danger]).to be_present
        end
      end

    end
    
    context "with unauthenticated user" do
      it "redirects to the root page" do
        post :sort, queue_array: [{ position: 1, id: 1 }, { position: 2, id: 2 }]
        expect(response).to redirect_to root_path
      end
    end
  end
  
end
  