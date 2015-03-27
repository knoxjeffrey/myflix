class ProcessStripePayment
  attr_reader :amount, :email, :token
  
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
    rescue Stripe::CardError => e
      return [false, e.message]
    end  
  end
end