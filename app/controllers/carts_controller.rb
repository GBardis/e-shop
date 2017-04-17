class CartsController < ApplicationController
  # before_action :validate_authorization_for_user
  before_action :order
  def show
    @order_items = @order_inprogress
  end

  def validate_authorization_for_user
    unless current_user
      redirect_to new_user_session_path
      flash[:notice] = 'Πρέπει να συνδεθείτε για να μπορείτε να δείτε το καλάθι'
    end
  end
end
private

def order
  if current_user && current_user.orders.exists?
    @order = Order.where(user_id: current_user.id ,status: 'in_progress')
    @order_inprogress = @order.order_items
  else
    @order_inprogress = current_order.order_items
  end
end
