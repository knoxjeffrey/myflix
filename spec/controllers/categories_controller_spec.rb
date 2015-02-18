require 'spec_helper'

describe CategoriesController do
  let!(:comedy) { object_generator(:category) }

  describe "GET index" do  
    let(:drama) { object_generator(:category) }
    
    it "assigns @categories for authenticated users" do
      session[:user_id] = object_generator(:user).id

      get :index
      expect(assigns(:categories)).to eq([comedy, drama])
    end
    
    it "redirects user to root page if user not authenticated" do
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe "GET show" do
    it "assigns @category for authenticated users" do
      session[:user_id] = object_generator(:user).id
      get :show, id: comedy
      expect(assigns(:category)).to eq(comedy)
    end
    
    it "redirects user to root page if user not authenticated" do
      get :show, id: comedy
      expect(response).to redirect_to root_path
    end
  end
end