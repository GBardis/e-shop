class ProductsController < ApplicationController
    before_action :set_category
    def index
        @products = if @category.present?
                        Product.where(category_id: @category)
                    else
                        Product.all
                    end
        @categories = Category.all.where(parent_id: nil)
        @subcategories = Category.all.where.not(parent_id: nil)
    end

    def create
        @products = Product.create(product_params)
    end

    private

    def set_category
        @category = Category.find(params[:category_id]) if params[:category_id]
    end

    def product_params
        params.require(:product).permit(:title, :description, :price, :stock, :category_id, :image, :products_id, :category)
    end
end
