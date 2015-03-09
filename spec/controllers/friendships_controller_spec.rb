require 'spec_helper'

describe FriendshipsController do
  
  describe "GET index" do
    
    context "with authenticted user do" do
      it "assigns @relationships as everyone the user is following" do
        user1 = object_generator(:user)
        set_current_user_session
        object_generator(:friendship, user: current_user, friend: user1)
        
        get :index
        expect(assigns(:friendships)).to eq([user1])
      end
    end
    
    context "with unauthenticted user do" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :index }
      end
    end
  end
  
  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:user_to_delete) { object_generator(:user) }
      
      before { set_current_user_session }
      
      context "with followed user associated with authenticated user" do
        
        before do 
          object_generator(:friendship, user: current_user, friend: user_to_delete)
          delete :destroy, id: user_to_delete
        end
        
        it "should redirect to people_path" do
          expect(response).to redirect_to people_path
        end
        
        it "should delete the relationship" do
          expect(Friendship.count).to eq(0)
        end
      end
      
      context "with user not associated with authenticated user" do
        it "should not delete user" do
          user2 = object_generator(:user)
          object_generator(:friendship, user: user2, friend: user_to_delete)
          delete :destroy, id: user_to_delete
          expect(Friendship.count).to eq(1)
        end
      end
    end
    
    context "with unauthenticted user do" do
      it_behaves_like "require_sign_in" do
        let(:action) { delete :destroy, id: 1 }
      end
    end
  end
end