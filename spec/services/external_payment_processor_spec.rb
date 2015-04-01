require 'spec_helper'

describe ExternalPaymentProcessor do
  
  describe :charge do
    
    context "with valid card details" do
      it "makes a successful charge", :vcr do
        token = create_external_payment_provider_token("4242424242424242")
        options = { amount: 999, email: 'knoxjeffrey@outlook.com', token: token }

        card_charge = ExternalPaymentProcessor.create_payment_process(options)
        
        expect(card_charge.processed).to be true
      end
    end
    
    context "with invalid card details" do
      let(:token){ create_external_payment_provider_token("4000000000000002") }
      let(:options) { { amount: 999, email: 'knoxjeffrey@outlook.com', token: token } }
      
      it "does not make a charge", :vcr do
        card_charge = ExternalPaymentProcessor.create_payment_process(options)
        
        expect(card_charge.processed).to be nil
      end
      
      it "returns an error message", :vcr do
        card_charge = ExternalPaymentProcessor.create_payment_process(options)
        
        expect(card_charge.error).to eq('Your card was declined.')
      end
    end
    
  end
end