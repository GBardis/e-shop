class OrderItemsController < ApplicationController
  def create
    # if @order.nil?
    @order = current_order
    @order_item = @order.order_items.new
    # .find_or_initialize_by(order_id: :order_id, quantity: :quantity)

    @order.save
    session[:order_id] = @order.id
    # else
    #  @order = current_order
    # @order_item = @order.order_items.find(params[:id])
    #  @order_item.quantity += 1
    #  @order_item.update_attributes(order_item.quantity)
    # @order_items = @order.order_items
    # end
  end

  def update
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.update_attributes(order_item_params)
    @order_items = @order.order_items
  end

  def destroy
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
