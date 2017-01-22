class UsersController < ApplicationController
  def set_user
  @user = User.find(params[:id])
end

def validate_authorization_for_user
   redirect_to root_path unless @user == current_user
end
end
