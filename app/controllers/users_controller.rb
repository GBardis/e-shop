class UsersController < ApplicationController
  before_action :validate_authorization_for_user
  before_action :require_owner
  def show; end

  def validate_authorization_for_user
    unless current_user
      redirect_to new_user_session_path
      flash[:notice] = 'Πρέπει να συνδεθείτε για να μπορείτε να δείτε το προφίλ σας'
    end
  end
  def require_owner
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:notice] = 'Δεν έχετε δικαίωμα προσπέλασης'
      redirect_to profile_path(current_user)
    else
      unless current_user.id ==  @user.id
        flash[:notice] = 'Δεν έχετε δικαίωμα προσπέλασης'
        redirect_to profile_path(current_user)
      end
    end
  end
end
