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
    context "valid personal details" do
      
      context "valid card details" do
      
        let(:attempt_card_payment) { double(:attempt_card_payment) }
        before do
          expect(attempt_card_payment).to receive(:processed).and_return(true)
          ExternalPaymentProcessor.stub(:create_payment_process).and_return(attempt_card_payment) 
        end
        after { ActionMailer::Base.deliveries.clear }

        it "creates user record" do
          post :create, user: generate_attributes_for(:user), stripeToken: '123'
          expect(User.count).to eq(1)
        end
    
        it "redirects to sign_in path" do
          post :create, user: generate_attributes_for(:user), stripeToken: '123'
          expect(response).to redirect_to sign_in_path
        end
      
        context "when user has been invited" do
          let(:inviter) { object_generator(:user) }
          let(:invitation) { object_generator(:invitation, inviter: inviter) }
        
          it "delegates to InvitationHandler to handle invitation" do
            handled_invitation = double("handled_invitation")                         
            allow(InvitationHandler).to receive(:new).and_return(handled_invitation)
            expect(handled_invitation).to receive(:handle_invitation)
            
            user_params = { email_address: invitation.recipient_email_address, password: 'password', full_name: invitation.recipient_name}
            post :create, user: user_params, invitation_token: invitation.token
          end
        end
        
        context "when user hasn't been invited" do
          let(:inviter) { object_generator(:user) }
          let(:invitation) { object_generator(:invitation, inviter: inviter) }
        
          it "does not delegate to InvitationHandler to handle invitation" do
            handled_invitation = double("handled_invitation")                         
            InvitationHandler.stub(:new).and_return(handled_invitation)
            expect(handled_invitation).not_to receive(:handle_invitation)
            
            post :create, user: generate_attributes_for(:user), stripeToken: '123'
          end
        end
      end
      
      context "invalid card details" do
        let(:attempt_card_payment) { double(:attempt_card_payment) }
        before do
          expect(attempt_card_payment).to receive(:processed).and_return(false)
          expect(attempt_card_payment).to receive(:error).and_return("error")
          ExternalPaymentProcessor.stub(:create_payment_process).and_return(attempt_card_payment)
          
          post :create, user: generate_attributes_for(:user), stripeToken: '123' 
        end
        after { ActionMailer::Base.deliveries.clear }
        
        it "does not create a user" do
          expect(User.count).to eq(0)
        end
        
        it "redirects to register_path" do
          expect(response).to render_template :new
        end
        
        it "generates a flash danger message" do
          expect(flash[:danger]).to be_present
        end
      end
      
    end
    
    context "invalid personal details" do
      let(:attempt_card_payment) { double(:attempt_card_payment) }
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
      
      it "does not charge the card" do
        attempt_card_payment.should_not receive(:successful?)
      end
    end
    
    context "sending emails" do
      context "valid input details" do
        let(:attempt_card_payment) { double(:attempt_card_payment) }
        before do 
          attempt_card_payment.stub(:processed).and_return(true)
          ExternalPaymentProcessor.stub(:create_payment_process).and_return(attempt_card_payment)
          post :create, user: { email_address: 'knoxjeffrey@outlook.com', password: 'password', full_name: 'Jeff Knox' }, stripeToken: '123'
        end
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