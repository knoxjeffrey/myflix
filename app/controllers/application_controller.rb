class ApplicationController < ActionController::Base
  protect_from_forgery
  
  #allow these methods to be used in the views as well
  helper_method :current_user, :logged_in?
  
  def current_user
    #if there's an authenticated user, return the user obj
    #else return nil
    #
    #uses memoization to stop the database being hit every time current_user method is called.  
    #If it's the first call then the database is hit and subsequent calls will use the value stored in the @current_user instance variable
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  #takes the current_user method and turns it into a boolean.  !!nil returns false 
  def logged_in?
    !!current_user 
  end
  
  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to do that"
      redirect_to root_path
    end
  end
  
end
