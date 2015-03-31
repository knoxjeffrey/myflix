class ExternalPaymentProcessor
  require "./lib/stripe_payment_processor.rb"

  attr_accessor :processed, :error
  
  def initialize(params)
    @processed = params[:processed]
    @error = params[:error]
  end

  def self.charge(params)
    response = payment_processor.new(params).process_card
    response == true ? new({ processed: response }) : new({ error: response })
  end

  private
  
  def self.payment_processor
    StripePaymentProcessor
  end
  
end