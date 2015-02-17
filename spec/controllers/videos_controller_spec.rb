require 'spec_helper'

describe VideosController do
  before do
    @fake_video = Fabricate(:video)
  end
  
  describe "GET show" do      
    it "assigns @video for authentucated users" do
      session[:user_id] = Fabricate(:user).id
      get :show, id: @fake_video
      expect(assigns(:video)).to eq(@fake_video)
    end

    it "redirects user to root page if user not authenticated" do
      get :show, id: @fake_video
      expect(response).to redirect_to root_path
    end
  end

  describe "POST search" do
    it "assigns @search_results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      post :search, video_title: @fake_video.title
      expect(assigns(:search_results)).to eq([@fake_video])
    end
    
    it "redirects user to root page if user not authenticated" do
      post :search, video_title: @fake_video.title
      expect(response).to redirect_to root_path
    end
  end
end
  
