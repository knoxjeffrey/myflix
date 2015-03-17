require 'spec_helper'

describe InvitationsController do

  describe "GET new" do
    
    context "with authenticated user" do
      it "assigns @invitation" do
        set_current_user_session
        get :new
        expect(assigns(:invitation)).to be_a_new_record
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end
    end
    
    context "with unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :new }
      end
    end
  end
  
  describe "POST create" do
    
    context "with authenticated user" do
      
      before { set_current_user_session }
      after { ActionMailer::Base.deliveries.clear }
      
      context "with valid input" do
        before { post :create, invitation: generate_attributes_for(:invitation, recipient_name: "Test Friend", recipient_email_address: "test@test.com") }
        
        it "redirects to the invite friend page" do
          expect(response).to redirect_to invite_friend_path
        end
        
        it "creates an invitation" do
          expect(Invitation.count).to eq(1)
        end
        
        it "sends an email to the invited friend" do
          expect(ActionMailer::Base.deliveries.last.to).to eq(['test@test.com'])
        end
        
        it "generates a successful flash message" do
          expect(flash[:success]).to be_present
        end
      end
      
      context "with invalid input" do
        before { post :create, invitation: generate_attributes_for(:invitation, recipient_name: "", recipient_email_address: "test@test.com") }
        it "does not create a new invitation" do
          expect(Invitation.count).to eq(0)
        end
        
        it "does not send out an invitation email" do
          expect(ActionMailer::Base.deliveries).to be_empty
        end
  
        it "renders the new template" do
          expect(response).to render_template :new
        end
        
        it "assigns @invitation" do
          expect(assigns(:invitation)).to be_present
        end
      end
    end
    
    context "with unauthenticated user" do
      it_behaves_like "require_sign_in" do
        let(:action) { post :create }
      end
    end
  end
  
end
