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
      
      context "when user has been invited" do
        let(:inviter) { object_generator(:user) }
        let(:invitation) { object_generator(:invitation, inviter: inviter) }
        
        before { post :create, user: { email_address: invitation.recipient_email_address, password: 'password',
                              full_name: invitation.recipient_name}, invitation_token: invitation.token }
        
        it "makes the user follow the inviter" do
          recipient = User.find_by_email_address(invitation.recipient_email_address)
          expect(recipient.follows?(inviter)).to be true
        end
        
        it "makes the inviter follow the user" do
          recipient = User.find_by_email_address(invitation.recipient_email_address)
          expect(inviter.follows?(recipient)).to be true
        end
        
        it "expires the invitation upon creation" do
          expect(Invitation.first.token).to be_nil
        end
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
    
    context "sending emails" do
      context "valid input details" do
        
        before { post :create, user: { email_address: 'knoxjeffrey@outlook.com', password: 'password', full_name: 'Jeff Knox' } }
        after { ActionMailer::Base.deliveries.clear }
        
        it "sends out the email" do
          expect(ActionMailer::Base.deliveries.last.to).to eq(['knoxjeffrey@outlook.com'])
        end
      
        it "sends email containing the users full name" do
          expect(ActionMailer::Base.deliveries.last.body).to include("Jeff Knox")
        end
      end
      
      context "invalid input details" do
        before { post :create, user: { email_address: 'junk' } }
        after { ActionMailer::Base.deliveries.clear }
        
        it "does not send an email" do
          expect(ActionMailer::Base.deliveries).to be_empty
        end
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
  
  describe "GET new_with_invitation_token" do
    context "with valid token" do
      let(:invitation) { object_generator(:invitation) }
      
      before { get :new_invitation_with_token, token: invitation.token }
      
      it "renders the :new view template" do
        expect(response).to render_template :new
      end
      
      it "assigns @user with recipient email" do
        expect(assigns(:user).email_address).to eq(invitation.recipient_email_address)
      end
      
      it "sets @invitation_token" do
        expect(assigns(:invitation_token)).to eq(invitation.token)
      end
    end
    
    context "with invalid token" do
      it "redirects to expired token path" do
        get :new_invitation_with_token, token: 'not valid'
        expect(response).to redirect_to expired_token_path
      end
    end
  end
end