class ProductsController < ApplicationController
  # before_action :set_product
  before_action :set_category

  def index
    @products = if @category.present?
                  Product.where(category_id: @category).page params[:page]
                else
                  Product.all.page params[:page]
     end
    @categories = Category.all.where(parent_id: nil)
    @subcategories = Category.all.where.not(parent_id: nil)
    @order_item = current_order.order_items.new
  end

  def show
    @products = Product.find(params[:id])
    @order_item = current_order.order_items.new

    @comments = Comment.where(product_id: @products).order('created_at DESC')
    # @images = @product.images
    @image_urls = []
    @products.images.each do |image|
      @image_urls.push(image.image.url)
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id]
  end

  def set_product
    @products = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:id, :title, :description, :price, :stock, :category_id, :image, :product_id, :category)
  end
end
