require 'spec_helper'

describe VideosController do
  let(:test_video) { object_generator(:video) }
  
  describe "GET show" do      
    it "assigns @video for authentucated users" do
      session[:user_id] = object_generator(:user).id
      get :show, id: test_video
      expect(assigns(:video)).to eq(test_video)
    end
    
    it "assigns @reviews for authenticated users" do
      session[:user_id] = object_generator(:user).id
      review1 = object_generator(:review, video: test_video)
      review2 = object_generator(:review, video: test_video, user: object_generator(:user))
      get :show, id: test_video
      expect(assigns(:video).reviews).to match_array([review1, review2])
    end

    it "redirects user to root page if user not authenticated" do
      get :show, id: test_video
      expect(response).to redirect_to root_path
    end
  end

  describe "POST search" do
    it "assigns @search_results for authenticated users" do
      session[:user_id] = object_generator(:user).id
      post :search, video_title: test_video.title
      expect(assigns(:search_results)).to eq([test_video])
    end
    
    it "redirects user to root page if user not authenticated" do
      post :search, video_title: test_video.title
      expect(response).to redirect_to root_path
    end
  end
end
  
