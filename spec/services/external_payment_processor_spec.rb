require 'spec_helper'

describe ExternalPaymentProcessor do
  
  describe :create_payment_process do
    
    context "with valid card details" do
      it "makes a successful charge", :vcr do
        token = create_external_payment_provider_token("4242424242424242")
        options = { amount: 999, email: 'knoxjeffrey@outlook.com', token: token }

        card_charge = ExternalPaymentProcessor.create_payment_process(options)
        
        expect(card_charge.successful?).to be true
      end
    end
    
    context "with invalid card details", :vcr do
      let(:token){ create_external_payment_provider_token("4000000000000002") }
      let(:options) { { amount: 999, email: 'knoxjeffrey@outlook.com', token: token } }
      
      it "does not make a charge" do
        card_charge = ExternalPaymentProcessor.create_payment_process(options)
        
        expect(card_charge.successful?).to be false
      end
      
      it "returns an error message" do
        card_charge = ExternalPaymentProcessor.create_payment_process(options)
        
        expect(card_charge.error).to eq('Your card was declined.')
      end
    end
    
  end
  
  describe :create_customer_subscription do
    
    context "with valid card details", :vcr do
      it "creates a customer" do
        token = create_external_payment_provider_token("4242424242424242")
        options = { email: 'knoxjeffrey@outlook.com', token: token }
        
        subscribe_customer = ExternalPaymentProcessor.create_customer_subscription(options)
        
        expect(subscribe_customer.successful?).to be true
      end
      
      it "returns the customer token" do
        token = create_external_payment_provider_token("4242424242424242")
        options = { email: 'knoxjeffrey@outlook.com', token: token }
        
        subscribe_customer = ExternalPaymentProcessor.create_customer_subscription(options)
        
        expect(subscribe_customer.customer_token).to be_present
      end
    end
    
    context "with invalid card details", :vcr do
      let(:token){ create_external_payment_provider_token("4000000000000002") }
      let(:options) { { email: 'knoxjeffrey@outlook.com', token: token } }
      
      it "does not create a customer" do
        subscribe_customer = ExternalPaymentProcessor.create_customer_subscription(options)
        
        expect(subscribe_customer.successful?).to be false
      end
      
      it "returns an error message" do
        subscribe_customer = ExternalPaymentProcessor.create_customer_subscription(options)
        
        expect(subscribe_customer.error).to eq('Your card was declined.')
      end
    end
    
  end
    
end