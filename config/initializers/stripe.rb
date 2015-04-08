Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do
  subscribe 'charge.succeeded' do |event|
    charge_info = event.data.object
    user = User.find_by(customer_token: charge_info.customer)
    Payment.create(user: user, amount: charge_info.amount, reference_id: charge_info.id)
  end
  
  subscribe 'charge.failed' do |event|
    charge_info = event.data.object
    user = User.find_by(customer_token: charge_info.customer)
    user.deactivate!
  end
end