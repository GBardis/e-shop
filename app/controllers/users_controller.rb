class UsersController < ApplicationController
  before_action :validate_authorization_for_user
  def show; end

  def validate_authorization_for_user
    unless current_user
      redirect_to new_user_session_path
      flash[:notice] = 'Πρέπει να συνδεθείτε για να μπορείτε να δείτε το προφίλ σας'
    end
  end
end
