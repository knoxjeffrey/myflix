require "spec_helper"

describe InvitationHandler do
  
  describe :handle_invitation do
    
    context "when user has been invited" do
      let(:inviter) { object_generator(:user) }
      let(:invitation) { object_generator(:invitation, inviter: inviter) }
      let(:invited_user) { object_generator(:user, email_address: invitation.recipient_email_address) }
      let(:options) { { user: invited_user, invitation_token: invitation.token } }

    
      it "makes the user follow the inviter" do
        invitation = InvitationHandler.new(options).handle_invitation
        recipient = User.find_by(email_address: invited_user.email_address)
        expect(recipient.follows?(inviter)).to be true
      end
    
      it "makes the inviter follow the user" do
        invitation = InvitationHandler.new(options).handle_invitation
        recipient = User.find_by(email_address: invited_user.email_address)
        expect(inviter.follows?(recipient)).to be true
      end
    
      it "expires the invitation upon creation" do
        invitation = InvitationHandler.new(options).handle_invitation
        expect(Invitation.first.token).to be_nil
      end
    end
  end
end