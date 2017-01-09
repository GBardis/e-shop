class ProductsController < ApplicationController
    before_action :set_category

    def index
        @products = if @category.present?
                        Product.where(category_id: @category).page params[:page]
                    else
                        Product.all.page params[:page]
                    end
        @categories = Category.all.where(parent_id: nil).page params[:page]
        @subcategories = Category.all.where.not(parent_id: nil).page params[:page]
    end

    def image_urls
        @product = Product.find(params[:id])
        @images = @product.images
end
    #     def show
    #         @products = Product.find(params[:id])
    #         @images = @products.images
    #         @image_urls = []
    #         @products.images.each do |image|
    #             @image_urls.push(image.image.url)
    #         end
    #         respond_to do |format|
    #             format.html # show.html.erb
    #             format.json { render json: @classified }
    #         end
    #        end

    private

    def set_category
        @category = Category.find(params[:category_id]) if params[:category_id]
    end

    def product_params
        params.require(:product).permit(:title, :description, :price, :stock, :category_id, :image, :products_id, :category)
    end
end