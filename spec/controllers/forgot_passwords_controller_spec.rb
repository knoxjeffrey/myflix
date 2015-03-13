require 'spec_helper'

describe ForgotPasswordsController do
  
  describe "POST create" do
    context "with valid input" do
      
      let(:valid_user) { object_generator(:user, email_address: 'knoxjeffrey@outlook.com') }
      before { post :create, email_address: valid_user.email_address }
      
      it "redirects to the forgot password confirmation page" do 
        expect(response).to redirect_to forgot_password_confirmation_path
      end
      
      it "sends an email the the email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['knoxjeffrey@outlook.com'])
      end
      
      it "generates a random token" do
        expect(valid_user.reload.token).to be_present
      end
      
    end
    
    context "with invalid input" do
      
      context "with blank input" do
        
        before { post :create, email_address: '' }
        it "redirects to forgot password page" do
          expect(response).to redirect_to forgot_password_path
        end
        
        it "shows an error message" do
          expect(flash[:danger]).to eq("Email cannot be blank. Please try again.")
        end
        
      end
      
      context "with email address not in database" do
        
        before { post :create, email_address: 'knoxy@outlook.com' }
        it "redirects to forgot password page" do
          expect(response).to redirect_to forgot_password_path
        end
        
        it "shows an error message" do
          expect(flash[:danger]).to eq("There is no user with that email in the system")
        end
        
      end
      
    end
    
  end
end