def set_current_user_session
  valid_user = object_generator(:user)
  session[:user_id] = valid_user.id
end

def current_user
  User.find(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end
