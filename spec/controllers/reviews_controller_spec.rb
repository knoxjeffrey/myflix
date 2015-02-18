require 'spec_helper'

describe ReviewsController do
  
  describe "POST create" do
    context "with authenticated user" do
      let(:valid_user) { object_generator(:user) }
      let(:new_video) { object_generator(:video) }
      
      before do 
        session[:user_id] = valid_user.id
      end
      
      context "with valid user input" do
            
        before do   
          post :create, review: generate_attributes_for(:review), video_id: new_video.id
        end
      
        it "creates a new review" do
          expect(Review.count).to eq(1)
        end
        
        it "creates a new review associated with the video" do
          expect(Review.first.video).to eq(new_video)
        end
        
        it "creates a new review associated with the user" do
          expect(Review.first.user).to eq(valid_user)
        end
        
        it "generates a successful flash message" do
          expect(flash[:success]).to be_present
        end
        
        it "redirects to the video show page" do
          expect(response).to redirect_to video_path(new_video)
        end
      end
      
      context "with invalid user input" do

        before do 
          post :create, review: {rating: 1}, video_id: new_video.id
        end
        
        it "does not create a new review" do
          expect(Review.count).to eq(0)
        end
        
        it "renders the videos/show page" do
          expect(response).to render_template('videos/show')
        end
        
        it "sets @video" do
          expect(assigns(:video)).to eq(new_video)
        end
        
        it "sets @reviews" do
          expect(assigns(:video).reviews).to match_array([])
        end
      end
    
    end
    
    
    context "with unauthenticated user" do
      let(:new_video) { object_generator(:video) }
      
      before do 
        post :create, review: {rating: 1}, video_id: new_video.id
      end
      
      it "redirects to the root page" do
        expect(response).to redirect_to root_path
      end
    end
  end
  
end