class OrderItemsController < ApplicationController
  def create
    # if @order.nil?
    @order = current_order
    @order_item = @order.order_items.new(order_item_params)
    @order.save
    session[:order_id] = @order.id
    respond_to do |format|
      format.js { render 'order_items/create' }
    end

    # else
    #  @order = current_order
    #  @order_item = @order.order_items.find(params[:id])
    #  @order_item.quantity += 1
    #  @order_item.update_attributes(order_item.quantity)
    #  @order_items = @order.order_items
    #  @order.save
    #  session[:order_id] = @order.id
    # end
  end

  def update
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.update_attributes(order_item_params)
    @order_items = @order.order_items
    respond_to do |format|
      format.js { render 'order_items/update' }
    end
  end

  def destroy
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items
    respond_to do |format|
      format.js { render 'order_items/destroy' }
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id)
  end
end
