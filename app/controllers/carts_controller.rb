class CartsController < ApplicationController
  # before_action :validate_authorization_for_user
  def show
    @order_items = if current_user && current_user.orders.exists?
                     current_user.orders.last.order_items
                   else
                     current_order.order_items
                   end
  end

  def validate_authorization_for_user
    unless current_user
      redirect_to new_user_session_path
      flash[:notice] = 'Πρέπει να συνδεθείτε για να μπορείτε να δείτε το καλάθι'
    end
  end
end
