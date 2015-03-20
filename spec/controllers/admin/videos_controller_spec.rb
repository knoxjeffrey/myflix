require 'spec_helper'

describe Admin::VideosController do
  
  describe "GET new" do
    
    context "if user is admin" do
      it "assigns @video to a new video" do
        set_current_admin_session
        get :new
        expect(assigns(:video)).to be_instance_of(Video)
        expect(assigns(:video)).to be_a_new_record
      end
    end
    
    context "if user is not admin" do
      it "redirects to the root path" do
        set_current_user_session
        get :new
        expect(response).to redirect_to root_path
      end
      
      it "displays a flash danger message" do
        set_current_user_session
        get :new
        expect(flash[:danger]).to be_present
      end
    end
    
    context "if user is not authenticated" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :new }
      end
    end
    
  end
end