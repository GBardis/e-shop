class OrdersController < ApplicationController
  def show
    @order = current_user.orders # unless current_user.orders.in_progress
  end

  def order_details
    @order_details = current_user.orders.last.order_items
  end
end
