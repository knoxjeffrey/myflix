require 'spec_helper'

describe CategoriesController do
  
  before do
    user = User.create(email_address: "knoxjeffrey@outlook.com", password: "password", full_name: "Jeff")
    request.session[:user_id] = user.id
  end
  
  describe "GET index" do
    it "assigns @categories" do
      comedy = Category.create(name: "Test Comedies")
      drama = Category.create(name: "Test Dramas")
      
      get :index
      expect(assigns(:categories)).to eq([comedy, drama])
    end
    
    it "renders the index template" do
      get :index
      expect(response).to render_template :index
    end
  end
  
  describe "GET show" do
    let(:comedy) {Category.create(name: "Test Comedies")}
    
    it "assigns @category" do
      get :show, id: comedy
      expect(assigns(:category)).to eq(comedy)
    end
    
    it "renders the show template" do
      get :show, id: comedy
      expect(response).to render_template :show
    end
  end
  
end