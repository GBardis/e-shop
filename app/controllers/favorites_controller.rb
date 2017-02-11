class FavoritesController < ApplicationController
  def show
    @favorite = current_user.favorite_products
    @order_item = current_order.order_items.new
  end
end
