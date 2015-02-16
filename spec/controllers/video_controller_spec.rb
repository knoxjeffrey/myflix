require 'spec_helper'

describe VideosController do
  
  before do
    user = User.create(email_address: "knoxjeffrey@outlook.com", password: "password", full_name: "Jeff")
    request.session[:user_id] = user.id
  end
  
  describe "GET show" do
    let(:monk) {Video.create(title: "Monk", description: "Adrian Monk is a brilliant San Francisco detective")}
    
    it "assigns @video" do
      get :show, id: monk
      expect(assigns(:video)).to eq(monk)
    end
    
    it "renders the show template" do
      get :show, id: monk
      expect(response).to render_template :show
    end
  end
  
  describe "POST search" do
    let(:monk) {Video.create(title: "Monk", description: "Adrian Monk is a brilliant San Francisco detective")}
    
    it "assigns @search_results" do
      post :search, video_title: "Monk"
      expect(assigns(:search_results)).to eq([monk])
    end
    
    it "renders the search template" do
      post :search, id: monk
      expect(response).to render_template :search
    end
    
  end
  
end