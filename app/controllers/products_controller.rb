class ProductsController < ApplicationController
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
    @product = Product.find(params[:id])
    @order_item = current_order.order_items.new

    @comments = Comment.where(product_id: @product).order('created_at DESC')
    # @images = @product.images
    @image_urls = []
    @product.images.each do |image|
      @image_urls.push(image.image.url)
    end
  end

  def favorite
    type = params[:type]
    @product = Product.find(params[:id])
    if type == 'favorite'
      current_user.favorites << @product
      respond_to do |format|
        format.js { render 'favorite_actions/favorite.js.erb' }
      end
    elsif type == 'unfavorite'
      current_user.favorites.delete(@product)
      respond_to do |format|
        format.js { render 'favorite_actions/favorite.js.erb' }
      end
    else
      # Type missing, nothing happens
      redirect_to :back # , notice: 'Nothing happened.'
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id]) if params[:category_id]
  end

  def product_params
    params.require(:product).permit(:id, :title, :description, :price, :stock, :category_id, :image, :product_id, :category)
  end
end
