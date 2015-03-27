class ProcessStripePayment
  attr_reader :controller, :email, :token
  
  def initialize(controller, email, token)
    @controller = controller
    @email = email
    @token = token
  end
  
  def charge_card
    begin
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      Stripe::Charge.create(
        amount: 999,
        currency: "gbp",
        source: token,
        description: "Sign up charge for #{email}"
      ) 
    rescue Stripe::CardError => e
      controller.flash[:danger] = e.message
      return false
    end  
  end
end