class StripePaymentProcessor
  
  attr_reader :amount, :email, :token
  attr_accessor :error_message, :is_successful
  
  def initialize(params)
    @amount = params[:amount]
    @email = params[:email]
    @token = params[:token]
  end
  
  def process_card
    begin
      charge = Stripe::Charge.create(
      amount: amount,
      currency: "gbp",
      source: token,
      description: "Charge for #{email}"
      )
      self.is_successful = true
    rescue Stripe::CardError => e
      self.error_message = e.message
    end 
  end

end