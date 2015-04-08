class ExternalPaymentProcessor
  require "#{Rails.root}/lib/stripe_payment_processor.rb"

  attr_accessor :processed, :error
  
  #creates a new instance of ExternalPaymentProcessor that sets either processed as the successful response or error as the error message
  #based on whether the response from the payment processor returns an id.
  def self.create_payment_process(options={})
    payment_response = payment_processor.new(options).process_card
    create_new_instance_from_response(payment_response)
  end
  
  def self.create_customer_subscription(options={})
    payment_response = payment_processor.new(options).subscribe_customer
    create_new_instance_from_response(payment_response)
  end
  
  def successful?
    processed.present?
  end
  
  def customer_token
    processed.id
  end

  private
  
  def initialize(options={})
    @processed = options[:processed]
    @error = options[:error]
  end
  
  def self.payment_processor
    StripePaymentProcessor
  end
  
  def self.create_new_instance_from_response(payment_response)
    payment_response.try(:id).present? ? new(processed: payment_response) : new(error: payment_response)
  end
  
end