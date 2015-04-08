require 'spec_helper'

describe 'Deactivate user on failed charge' do
  
  let(:event_data) do
    {
      "id" => "evt_15pF2nHKQF0Nl4V6p6hZA7oS",
      "created" => 1428483621,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15pF2nHKQF0Nl4V66gthOpky",
          "object" => "charge",
          "created" => 1428483621,
          "livemode" => false,
          "paid" => false,
          "status" => "failed",
          "amount" => 999,
          "currency" => "gbp",
          "refunded" => false,
          "source" => {
            "id" => "card_15pF1gHKQF0Nl4V6CMT7I7Jd",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 4,
            "exp_year" => 2016,
            "fingerprint" => "28HCaSm99cD0Xpct",
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
            "customer" => "cus_60zoM8D3o61YcN"
          },
          "captured" => false,
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_60zoM8D3o61YcN",
          "invoice" => nil,
          "description" => "this will fail",
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
            "url" => "/v1/charges/ch_15pF2nHKQF0Nl4V66gthOpky/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_61HcD5FWrkFtxL",
      "api_version" => "2015-03-24"
    }
  end
  
  it "deactivates a user with the webhook data from stripe for charge failed", :vcr do
    valid_user = object_generator(:user, customer_token: "cus_60zoM8D3o61YcN")
    post "/stripe_events", event_data
    expect(valid_user.reload).not_to be_active
  end
  
end