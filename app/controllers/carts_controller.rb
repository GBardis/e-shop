class CartsController < ApplicationController
  # #before_action :validate_authorization_for_user
  # before_action :page_title
  def show
    if current_user && !@order_inprogress.blank?
      @order = Order.where(user_id: current_user.id ,status: 'in_progress').take(1)
      @order_items = @order.last.order_items
    else
      @order_items = current_order.order_items
    end

    def page_title
      @meta_title = meta_title 'Αγαπημένα'
    end

    def validate_authorization_for_user
      unless current_user
        redirect_to new_user_session_path
        flash[:notice] = 'Πρέπει να συνδεθείτε για να μπορείτε να δείτε το καλάθι'
      end
    end
  end
end
