class PagesController < ApplicationController
  
  def home
    redirect_to home_path if logged_in?
  end
  
end