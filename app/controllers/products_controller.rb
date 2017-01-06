class ProductsController < ApplicationController
    before_action :set_category
    before_action :image_urls
    def index
        @products = if @category.present?
                        Product.where(category_id: @category)
                    else
                        Product.all
                    end
        @categories = Category.all.where(parent_id: nil)
        @subcategories = Category.all.where.not(parent_id: nil)
        @products = Product.find(params[:id])
        @images = @products.images
        @image_urls = []
        @products.images.each do |image|
            @image_urls.push(image.image.url)
        end

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @images }
        end
    end

    # def show
    # @classified = Classified.find(params[:id])
    #  @photos = @classified.photos # CW
    #  @image_urls = []
    #  @classified.photos.each do |photo|
    #      @image_urls.push(photo.image.url)
    #  end
    #  respond_to do |format|
    # format.html # show.html.erb
    # format.json { render json: @classified }
    # end
    # end
    def image_urls
        @products = Product.find(params[:id])
        @images = @products.images
  end

    private

    def set_category
        @category = Category.find(params[:category_id]) if params[:category_id]
    end

    def product_params
        params.require(:product).permit(:title, :description, :price, :stock, :category_id, :images, :product_id, :category)
    end
end
