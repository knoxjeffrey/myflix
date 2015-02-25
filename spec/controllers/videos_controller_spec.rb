require 'spec_helper'

describe VideosController do
  let(:test_video) { object_generator(:video) }
  
  describe "GET show" do    
    context "with authenticted user do" do
      it "assigns @video" do
        set_current_user_session
        get :show, id: test_video
        expect(assigns(:video)).to eq(test_video)
      end
    
      it "assigns @reviews" do
        set_current_user_session
        review1 = object_generator(:review, video: test_video)
        review2 = object_generator(:review, video: test_video, user: current_user)
        get :show, id: test_video
        expect(assigns(:video).reviews).to match_array([review1, review2])
      end
    end
    
    context "with unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :show, id: test_video }
      end
    end
  end

  describe "POST search" do
    it "assigns @search_results for authenticated users" do
      set_current_user_session
      post :search, video_title: test_video.title
      expect(assigns(:search_results)).to eq([test_video])
    end
    
    it_behaves_like "require_sign_in" do
      let(:action) { post :search, video_title: test_video.title }
    end
  end
end
  
