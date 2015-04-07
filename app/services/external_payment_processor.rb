class ExternalPaymentProcessor
  require "#{Rails.root}/lib/stripe_payment_processor.rb"

  attr_accessor :processed, :error
  
  #creates a new instance of ExternalPaymentProcessor that sets either processed as true or error as the error message
  #based on the response from the payment processor
  def self.create_payment_process(options={})
    response = payment_processor.new(options).process_card
    response == true ? new(processed: response) : new(error: response)
  end
  
  def self.create_customer_subscription(options={})
    response = payment_processor.new(options).subscribe_customer
    response == true ? new(processed: response) : new(error: response)
  end

  private
  
  def initialize(options={})
    @processed = options[:processed]
    @error = options[:error]
  end
  
  def self.payment_processor
    StripePaymentProcessor
  end
  
end