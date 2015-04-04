class ExternalPaymentProcessor
  require "#{Rails.root}/lib/stripe_payment_processor.rb"

  attr_accessor :processed, :error

  def self.create_payment_process(options={})
    response = payment_processor.new(options).process_card
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