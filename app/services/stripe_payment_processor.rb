class StripePaymentProcessor
  
  attr_reader :amount, :email, :token
  attr_accessor :error_message, :is_successful

  def initialize(amount, email, token)
    @amount = amount
    @email = email
    @token = token
  end
 
  def charge_card
    begin
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      Stripe::Charge.create(
      amount: amount,
      currency: "gbp",
      source: token,
      description: "Charge for #{email}"
      )
      self.is_successful = true
    rescue Stripe::CardError => e
      self.error_message = e.message
    end 
    self
  end
  
end