class ProductsController < ApplicationController
  before_action :page_title, only: [:index]
  before_action :set_order_item
  before_action :set_category
  before_action :seo, only: [:show]
  helper_method :sort_column, :sort_direction

  def index
    @categories = Category.all.where(parent_id: nil)
    @subcategories = Category.all.where.not(parent_id: nil)

    @products = if @category.present?
      Product.includes(:images).where(category_id: @category).order(sort_column + ' ' + sort_direction).page params[:page]
      #byebug
    else
      Product.includes(:images).order(sort_column + ' ' + sort_direction).page params[:page]
    end
    @order_item = current_order.order_items.new
    @meta_title = meta_title 'ΑΡΧΙΚΗ'
    @meta_description = "Είδη δώρων, κάρτες και παιχνίδια"
  end

  def show
    @product = Product.find_by_slug!(params[:id])
    @order_item = current_order.order_items.new
    # @image_urls = []
    # @product.images.each do |image|
    #   @image_urls.push(image.image.url)
    # end
  end

  def favorite
    type = params[:type]
    @product = Product.find_by_slug(params[:id])
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
    elsif type == 'deletefavorite'
      current_user.favorites.delete(@product)
      respond_to do |format|
        format.js { render 'favorite_actions/favorite_delete.js.erb' }
      end
    else

      redirect_to :back
    end
  end

  private

  def page_title
    @meta_title = meta_title 'ΑΡΧΙΚΗ'
    @meta_description = "Είδη δώρων, κάρτες και παιχνίδια"
  end

  def seo
    begin
      @product = Product.includes(:images).find_by_slug!(params[:id])
      @meta_title = meta_title @product.title
      @comments = Comment.where(product_id: @product).order('created_at DESC')
      @canonical_url = "/products/#{@product.slug}"
      @og_properties = {
        title: @meta_title,
        type:  'website',
        image: view_context.image_url('favicon/favicon_1'),  # this file should exist in /app/assets/images/logo.png
        url: @canonical_url
      }
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Το προιόν που ψάχνεται δεν υπάρχει "
      redirect_to root_path
    end
  end

  def sort_column
    %w(price created_at).include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end

  def set_category
    begin
      @category = Category.find(params[:category_id]) if params[:category_id]
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "H κατηγορία που ψάχνεται δεν υπάρχει που ψάχνεται δεν υπάρχει "
      redirect_to root_path
    end
  end

  def set_order_item
    @order_item = OrderItem.find(params[:product_id]) if params[:product_id]
  end

  def product_params
    params.require(:product).permit(:id, :title, :description, :price, :stock, :category_id, :image, :product_id, :category)
  end
end
