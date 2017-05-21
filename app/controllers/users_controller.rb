class UsersController < ApplicationController
  before_action :validate_authorization_for_user
  before_action :require_owner
  before_action :page_title
  def show; end

  private

  def page_title
    @meta_title = meta_title "#{current_user.name} #{current_user.lastname}"
  end

  def validate_authorization_for_user
    unless current_user
      redirect_to new_user_session_path
      flash[:notice] = 'Πρέπει να συνδεθείτε για να μπορείτε να δείτε το προφίλ σας'
    end
  end
  def require_owner
    begin
      @user = User.find_by(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      unless current_user.id ==  @user.id
        redirect_to profile_path(current_user)
        flash[:notice] = 'Δεν έχετε δικαίωμα προσπέλασης'
      end
    end
  end
end
