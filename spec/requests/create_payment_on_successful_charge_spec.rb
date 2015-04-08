require 'spec_helper'

describe "Create payment on successful charge" do
  
  let(:event_data) do
    {
      "id" => "evt_15otUBHKQF0Nl4V6P32npDqY",
      "created" => 1428400751,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_15otUBHKQF0Nl4V63YD9IWT6",
          "object" => "charge",
          "created" => 1428400751,
          "livemode" => false,
          "paid" => true,
          "status" => "succeeded",
          "amount" => 999,
          "currency" => "gbp",
          "refunded" => false,
          "source" => {
            "id" => "card_15otU9HKQF0Nl4V6RmxN2794",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 4,
            "exp_year" => 2015,
            "fingerprint" => "6lWhPIX7MfuqxkVU",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "metadata" => {},
            "customer" => "cus_60vKaWIn4BUzXr"
          },
          "captured" => true,
          "balance_transaction" => "txn_15otUBHKQF0Nl4V6IJkAxQVS",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_60vKaWIn4BUzXr",
          "invoice" => "in_15otUBHKQF0Nl4V6gKSsP6BO",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "application_fee" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15otUBHKQF0Nl4V63YD9IWT6/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_60vKtXvoFmgoxA",
      "api_version" => "2015-03-24"
    }
  end
  
  it "creates a payment with the webhook from stripe for a successful charge", :vcr do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end
  
  it "creates a payment associated with the user", :vcr do
    valid_user = object_generator(:user, customer_token: 'cus_60vKaWIn4BUzXr')
    post '/stripe_events', event_data
    
    expect(Payment.first.user).to eq(valid_user)
  end
  
  it "creates a payment with an amount", :vcr do
    valid_user = object_generator(:user, customer_token: 'cus_60vKaWIn4BUzXr')
    post '/stripe_events', event_data
    
    expect(Payment.first.amount).to eq(999)
  end
  
  it "creates a payment with a reference" do
    valid_user = object_generator(:user, customer_token: 'cus_60vKaWIn4BUzXr')
    post '/stripe_events', event_data
    
    expect(Payment.first.reference_id).to eq('ch_15otUBHKQF0Nl4V63YD9IWT6')
  end
  
end