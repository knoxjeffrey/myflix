class AdminsController < ApplicationController
  before_filter :require_user
  before_filter :require_admin
  
  private
  
  def require_admin
    unless current_user.admin?
      flash[:danger] = "You do not have access to that area."
      redirect_to root_path
    end
  end
end