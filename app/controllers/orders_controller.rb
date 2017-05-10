class OrdersController < ApplicationController
  before_action :page_title
  def show
    @orders = Order.where(user_id: current_user.id, status:[0,2,3]).order('created_at DESC')
  end

  def order_details
    @order = Order.find(params[:id])
    @order_details = @order.order_items.order('created_at DESC')
  end

  private
  def page_title
    @meta_title = meta_title 'Ιστορικό Παραγγελιών'
  end
end
