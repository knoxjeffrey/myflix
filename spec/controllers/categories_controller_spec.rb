require 'spec_helper'

describe CategoriesController do
  before do  
    @comedy = Fabricate(:category)
  end
  
  describe "GET index" do  
    before do  
      @drama = Fabricate(:category)
    end
    it "assigns @categories for authenticated users" do
      session[:user_id] = Fabricate(:user).id

      get :index
      expect(assigns(:categories)).to eq([@comedy, @drama])
    end
    
    it "redirects user to root page if user not authenticated" do
      get :index
      expect(response).to redirect_to root_path
    end
  end

  describe "GET show" do
    it "assigns @category for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :show, id: @comedy
      expect(assigns(:category)).to eq(@comedy)
    end
    
    it "redirects user to root page if user not authenticated" do
      get :show, id: @comedy
      expect(response).to redirect_to root_path
    end
  end
end