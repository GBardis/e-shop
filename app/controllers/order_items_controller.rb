class OrderItemsController < ApplicationController
  def create
    if current_user.orders.last.order_items.empty?
      @order = current_order
      @order.user_id = current_user.id
      @order_item = @order.order_items.new(order_item_params)
      @order.save
      session[:order_id] = @order.id
      respond_to do |format|
        format.js { render 'order_items/create.js.erb' }
      end
    else
      @order = current_user.orders.last
      @order_item = @order.order_items.find(params[:id])
      @order_item.update_attribute(:quantity, @order_item.quantity += 1)
      @order_items = @order.order_items
      respond_to do |format|
        format.js { render 'order_items/create.js.erb' }
      end
    end
  end

  def update
    @order = current_user.orders.last
    @order_item = @order.order_items.first
    @order_item.update_attributes(order_item_params)
    @order_items = @order.order_items
    respond_to do |format|
      format.js { render 'order_items/update.js.erb' }
    end
  end

  def destroy
    @order = current_user.orders.last
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items
    # if @order.nil?
    #  session.delete[:order_id]
    # @order.delete
    # end
    respond_to do |format|
      format.js { render 'order_items/destroy.js.erb' }
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:quantity, :product_id, :order_id, :user_id)
  end
end
