require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    context "with valid token" do
      
      let!(:valid_user) { object_generator(:user, token: '123456789') }
      before { get :show, id: '123456789' }
      
      it "renders show template" do
        expect(response).to render_template :show
      end
      
      it "sets @token" do
        expect(assigns(:token)).to eq('123456789')
      end
    end 
    
    context "with invalid token" do
      it "redirects to expired token page" do
        get :show, id: '123456789'
        expect(response).to redirect_to expired_token_path
      end
    end 
  end
  
  describe "POST create" do
    context "with valid token" do
      
      let!(:valid_user) { object_generator(:user, token: '123456789', password: 'old_password') }
      before { post :create, token: '123456789', password: 'new_password' }
      
      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
      
      it "updates the users password" do
        expect(valid_user.reload.authenticate('new_password')).to be_truthy
      end 
      
      it "sets a successful flash message" do
        expect(flash[:success]).to be_present
      end
      
      it "deletes the users token" do
        expect(valid_user.reload.token).not_to be_present
      end
    end
    
    context "with invalid token" do
      it "redirects to the expired token path" do
        post :create, id: '123456789', password: 'new_password'
        expect(response).to redirect_to expired_token_path
      end
      
    end
  end
end
