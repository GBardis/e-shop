class CartsController < ApplicationController
  before_action :validate_authorization_for_user
  def show
    if current_user.orders.in_progress.exists?
      @order_items = current_user.orders.last.order_items
    end
  end

  def validate_authorization_for_user
    unless current_user
      redirect_to new_user_session_path
      flash[:notice] = 'Πρέπει να συνδεθείτε για να μπορείτε να δείτε το καλάθι'
    end
  end
end
