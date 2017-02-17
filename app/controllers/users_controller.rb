class UsersController < ApplicationController
  before_action :validate_authorization_for_user
  def show
    @user = User.find(params[:id])
  end

  def validate_authorization_for_user
    redirect_to root_path unless current_user
  end
end
