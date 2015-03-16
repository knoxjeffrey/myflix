require 'spec_helper'

describe Invitation do
  it { should validate_presence_of :recipient_email_address }
  it { should validate_presence_of :recipient_name }
  it { should validate_presence_of :message }
  
  it { should validate_uniqueness_of :recipient_email_address }
  
  it { should_not allow_value("test@test").for(:recipient_email_address) }
  it { should allow_value("test@test.com").for(:recipient_email_address) }
  
  describe :clear_token_column do
    it "sets token column to nil" do
      invitation = object_generator(:invitation)
      invitation.clear_token_column
      expect(Invitation.last.token).to eq(nil)
    end
  end
end