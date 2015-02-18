require 'spec_helper'

describe UsersController do
  
  describe "GET new" do
    it "assigns @user if not logged in" do
      get :new
      expect(assigns(:user)).to be_a_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
    
    it "redirects to home path if already logged in" do
      session[:user_id] = object_generator(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end
  
  describe "POST create" do
    context "valid input details" do
      before { post :create, user: generate_attributes_for(:user) }
      
      it "creates user record" do
        expect(User.count).to eq(1)
      end
    
      it "redirects to sign_in path" do
        expect(response).to redirect_to sign_in_path
      end
    end
    
    context "invalid input details" do
      before { post :create, user: { email_address: 'junk' } }
      
      it "does not create user record" do
        expect(User.count).to eq(0)
      end
  
      it "renders the new template" do
        expect(response).to render_template :new
      end
  
      it "assigns @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end