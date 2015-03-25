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
      context "if user is not admin" do
        it_behaves_like "require_admin" do
          let(:action) { post :create }
        end
      end
    end
    
    context "if user is not authenticated" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :new }
      end
    end
    
  end
  
  describe "POST create" do
    
    context "if user is not authenticated" do
      it_behaves_like "require_sign_in" do
        let(:action) { post :create }
      end
    end
    
    context "if user is not admin" do
      it_behaves_like "require_admin" do
        let(:action) { post :create }
      end
    end
    
    context "if user is admin" do
      context "with valid input" do
        
        let(:new_category) { object_generator(:category) }
        let(:new_video) { object_generator(:video) }
      
        before do 
          set_current_admin_session
          post :create,  video: { title: "Monk", description: "tv series", category_id: new_category.id }
        end
        
        it "redirects to the admin_add_video path" do
          expect(response).to redirect_to admin_add_video_path
        end
        
        it "creates a video" do
          expect(new_category.videos.count).to eq(1)
        end 
      
        it "generates a flash succuss message" do
          expect(flash[:success]).to be_present
        end
      end
      
      context "with invalid input" do
        
        let(:new_category) { object_generator(:category) }
        
        before do 
          set_current_admin_session
          post :create,  video: { description: "failure" }
        end
        
        it "does not create a video" do
          expect(new_category.videos.count).to eq(0)
        end
        
        it "renders the new template" do
          expect(response).to render_template :new
        end
        
        it "assigns @video" do
          expect(assigns(:video)).to be_instance_of(Video)
        end
        
        it "shows error messages" do
          expect(current_user.errors).not_to be_nil
        end
      end
    end
  end
end