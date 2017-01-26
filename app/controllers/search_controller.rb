class SearchController < ApplicationController
    def search
        @products = if params[:q].nil?
                        []
                    else
                        Product.search params[:q]
                    end
        @order_item = current_order.order_items.new
  end
end
