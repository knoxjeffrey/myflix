class StripePaymentProcessor
  
  attr_reader :amount, :email, :token
  attr_accessor :error_message, :is_successful
  
  def initialize(options={})
    @amount = options[:amount]
    @email = options[:email]
    @token = options[:token]
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
  
  def subscribe_customer
    begin
      customer = Stripe::Customer.create(
        :source => token,
        :plan => "myflix",
        :email => email
      )
      self.is_successful = true
    rescue Stripe::CardError => e
      self.error_message = e.message
    end
  end

end