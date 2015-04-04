def set_current_user_session
  valid_user = object_generator(:user)
  session[:user_id] = valid_user.id
end

def set_current_admin_session
  valid_user = object_generator(:admin)
  session[:user_id] = valid_user.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def create_external_payment_provider_token(card_number)
  token = Stripe::Token.create(
            :card => {
              :number => card_number,
              :exp_month => Time.now.month,
              :exp_year => Time.now.year,
              :cvc => "123"
            },
          ).id
end
