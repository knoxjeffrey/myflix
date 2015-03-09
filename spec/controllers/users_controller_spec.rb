require 'spec_helper'

describe UsersController do
  
  describe "GET new" do
    it "assigns @user if not logged in" do
      get :new
      expect(assigns(:user)).to be_a_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
    
    it "redirects to home path if already logged in" do
      set_current_user_session
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
  
  describe "GET show" do
    let(:chosen_user) { object_generator(:user) }
    context "with authenticted user do" do
      
      before do
        set_current_user_session
        get :show, id: chosen_user
      end
      
      it "assigns @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
    
    context "with unauthenticted user do" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :show, id: chosen_user }
      end
    end
  end
end