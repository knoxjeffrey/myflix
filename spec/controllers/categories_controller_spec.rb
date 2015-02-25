require 'spec_helper'

describe CategoriesController do
  let!(:comedy) { object_generator(:category) }

  describe "GET index" do  
    let(:drama) { object_generator(:category) }
    
    it "assigns @categories for authenticated users" do
      set_current_user_session

      get :index
      expect(assigns(:categories)).to eq([comedy, drama])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "GET show" do
    it "assigns @category for authenticated users" do
      set_current_user_session
      get :show, id: comedy
      expect(assigns(:category)).to eq(comedy)
    end
    
    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: comedy }
    end
  end
end