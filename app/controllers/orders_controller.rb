class OrdersController < ApplicationController
  def show
    if current_user
      @orders = current_user.orders.order('created_at DESC') # unless current_user.orders.in_progress
    end
  end

  def order_details
    @order = Order.find(params[:id])
    @order_details = current_user.orders.last.order_items.order('created_at DESC')
  end
end
