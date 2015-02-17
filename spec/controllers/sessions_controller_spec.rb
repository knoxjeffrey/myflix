require 'spec_helper'

describe SessionsController do
  
  describe "GET new" do
    it "redirects to home path if already logged in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end
  
  describe "POST create" do
    context "valid input details" do
      before do
        @valid_user = Fabricate(:user)
        post :create, email_address: @valid_user.email_address, password: @valid_user.password
      end
      
      it "creates new session id from user id" do
        expect(session[:user_id]).to eq(@valid_user.id)
      end
      
      it "generates a successful flash message" do
        expect(flash[:success]).to be_present
      end
  
      it "redirects to home page" do
        expect(response).to redirect_to home_path
      end
    end
    
    context "invalid input details" do
      before do
        valid_user = Fabricate(:user)
        post :create, email_address: valid_user.email_address, password: 'aa'
      end
      
      it "does not create a new session id" do
        expect(session[:user_id]).to eq(nil)
      end
      
      it "generates a danger flash message" do
        expect(flash[:danger]).to be_present
      end
      
      it "redirects to sign in path" do 
        expect(response).to redirect_to sign_in_path
      end
    end
  end
  
  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    
    it "sets the session user id as nil" do
      expect(session[:user_id]).to eq(nil)
    end
    
    it "generates a danger flash message" do
      expect(flash[:danger]).to be_present
    end
    
    it "redirects to root path" do 
      expect(response).to redirect_to root_path
    end
  end
  
end